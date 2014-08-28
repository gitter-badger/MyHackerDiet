require 'csv'

class WeightsController < ApplicationController
  # GET /weights
  # GET /weights.xml
  before_filter :authenticate_user!

  def index
    @weight = Weight.new # new empty weight if user wants to create a new record

    respond_to do |format|
      format.html do
        @graph_one_week = "/weight_graphs/weight_graphs?title=Last Week&time=1.week.ago&size=400x150"
        @graph_two_weeks = "/weight_graphs/weight_graphs?title=Two Weeks&time=2.weeks.ago&size=400x150"
        @graph_two_months = "/weight_graphs/weight_graphs?title=Two Months&time=2.months.ago&size=400x150"
        @graph_three_months = "/weight_graphs/weight_graphs?title=Three Months&time=3.months.ago&size=400x150"

        @graph_week_big = "/weight_graphs/weight_graphs?title=Last Week&time=1.week.ago&size=800x300"
        @graph_two_weeks_big = "/weight_graphs/weight_graphs?title=Two Weeks&time=2.weeks.ago&size=800x300"
        @graph_two_months_big = "/weight_graphs/weight_graphs?title=Two Months&time=2.months.ago&size=800x300"
        @graph_three_months_big = "/weight_graphs/weight_graphs?title=Three Months&time=3.months.ago&size=800x300"

        @weights = Weight.where(:user_id => current_user.id).order('rec_date DESC').page(params[:page]).per(20)
      end
      format.xml  { render :xml => @weights }
      format.csv do
        @weights = Weight.find(:all, :conditions => ["user_id = ?", current_user.id])   # get all the weights, not just this page

        csv_string = CSV.generate do |csv|
          # header row
          csv << ["rec_date", "weight", "avg_weight", "bodyfat"]

          #data rows
          @weights.each do |s|
            csv << [s.rec_date, s.weight, s.avg_weight, s.bodyfat]
          end
        end

        send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=weights.csv"
      end
    end
  end

  def weight_graphs
    title = params[:title]
    size  = params[:size]
    time = params[:time]

    time_str = time.split(".")[0].to_i.send(time.split(".")[1]).ago

    g = current_user.graph_code(title, time_str, size)
    send_data(g, :filename => "any.png", :type => 'image/png', :disposition=> 'inline')
  end

  #
  # GET /weights/1
  # GET /weights/1.xml
  def show
    @weight = Weight.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weight }
    end
  end

  # GET /weights/new
  # GET /weights/new.xml
  def new
    @weight = Weight.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weight }
    end

  end

  # GET /weights/1/edit
  def edit
    @weight = Weight.find(params[:id])
  end

  # POST /weights
  # POST /weights.xml
  def create
    @weight = Weight.new(weight_params)
    @weight.user = current_user
    @weight.calc_avg_weight

    respond_to do |format|
      if @weight.save
        flash[:notice] = 'Weight was successfully created.'
        format.html { redirect_to(weights_url) }
        format.xml  { render :xml => @weight, :status => :created, :location => @weight }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weights/1
  # PUT /weights/1.xml
  def update
    @weight = Weight.find(params[:id])
    @weight.rec_type = RECTYPE['manual']
    @weight.calc_avg_weight

    weights_after = Weight.find_all_by_user_id(current_user.id, :conditions => ["rec_date > ?", @weight.rec_date], :order => 'rec_date ASC')
    weights_after.each do |w|
      w.calc_avg_weight
      w.save
    end

    respond_to do |format|
      if @weight.update_attributes(params[:weight])
        flash[:notice] = 'Weight was successfully updated.'
        format.html { redirect_to(weights_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weights/1
  # DELETE /weights/1.xml
  def destroy
    @weight = Weight.find(params[:id])
    @weight.destroy
    flash[:notice] = 'Record successfully deleted'

    respond_to do |format|
      format.html { redirect_to(weights_url) }
      format.xml  { head :ok }
    end
  end

  def csv_import 
    @parsed_file = CSV.parse(params[:dump][:file].read)
    n=0
    @parsed_file.each  do |row|
      c=Weight.new

      begin
        if row[0] =~ %r{(\d+)/(\d+)/(\d+)}
          c.rec_date = Date.parse "#{$3.to_i}-#{$1.to_i}-#{$2.to_i}"
        else
          c.rec_date= row[0]
        end

        c.weight=row[1]

        if row[2].to_i < 100
          c.bodyfat=row[2]
        elsif row.size >= 4  && row[3].to_i < 100
          c.bodyfat=row[3]
        end

        c.user_id = current_user.id

        valid = true
        valid=false if c.weight == nil || c.weight == 0
        #valid=false if c.bodyfat == nil || c.bodyfat == 0

        if valid && c.save
          n=n+1
          GC.start if n%50==0
        end
      rescue
      end
      flash[:notice]="CSV Import Successful,  #{n} new records added to database"
    end

    # Recalculate the average weight
    weights_after = Weight.find_all_by_user_id(current_user.id, :order => 'rec_date ASC')
    weights_after.each do |w|
      w.calc_avg_weight
      w.save
    end

    redirect_to weights_url
  end


  private

  def weight_params
    params.require(:weight).permit(:rec_date, :weight, :bodyfat)
  end
end


