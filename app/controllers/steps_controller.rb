class StepsController < ApplicationController
  require 'csv'

  # GET /steps
  # GET /steps.xml
  # GET /steps.csv
  before_filter :authenticate_user!

  def index
    @step = Step.new


    respond_to do |format|
      format.html do
        @steps = Step.where(:user_id => current_user.id).order('rec_date DESC').page(params[:page]).per(20)
      end
      format.xml  { render :xml => @steps }
      format.csv do
        @steps = Step.find(:all, :conditions => ["user_id = ?", current_user.id], :order => "rec_date");
        csv_string = CSV.generate do |csv|
          # header row
          csv << ["rec_date", "steps", "mod_steps", "mod_min"]

          # data rows
          @steps.each do |s|
            csv << [s.rec_date, s.steps, s.mod_steps, s.mod_min]
          end
        end

        send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=steps.csv"
      end
    end
  end

  def graph
    graph = graph_code()
    send_data(graph, :filename => "steps.png", :type => 'image/png', :disposition=> 'inline')

  end

  def graph_code
    recDates  = []
    totalSteps = []
    modSteps = []

    steps = Step.where(:user_id == current_user.id).order(:rec_date).limit(20)

    steps.reverse.each do |c|
      c.steps = c.steps == nil ? 0 : c.steps
      c.mod_steps = c.mod_steps == nil ? 0 : c.mod_steps

      recDates  << c.rec_date
      totalSteps << c.steps-c.mod_steps
      modSteps << c.mod_steps
    end

    manchart = 'http://chart.apis.google.com/chart?cht=bvs&chtt=Step+Chart+for+' + current_user.email + '&chs=800x300&chd=t:'
    manchart_suffix = '&chco=4d89f9,c6d9fd&chds=0,20000&chbh=20&chxt=x,y&chm=r,000000,0,0.498,0.501&chxl=1:|0|5k|10k|15k|20k|0:'

    dates = ''
    data = ''
    data1 = ''

    recDates.each do |rd|
      puts "rd is #{rd}"
      dates << "|#{rd.to_date.day.to_s}" rescue 0
    end

    totalSteps.each do |ts|
      data << ts.to_s + ','
    end

    modSteps.each do |ms|
      data1 << ms.to_s + ','
    end

    url = manchart + data1.chop + '|' + data.chop + manchart_suffix + dates
    puts "url is: #{url}"
    h = HTTParty.get(URI.encode(url))
    return h.body

end


  # GET /steps/1
  # GET /steps/1.xml
  def show
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = Step.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    @step = Step.new(step_params)
    @step.user = current_user

    respond_to do |format|
      if @step.save
        flash[:notice] = 'Step was successfully created.'
        format.html { redirect_to(steps_url) }
        format.xml  { render :xml => @step, :status => :created, :location => @step }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    @step = Step.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        flash[:notice] = 'Step was successfully updated.'
        format.html { redirect_to(steps_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = Step.find(params[:id])
    @step.destroy
    flash[:notice] = 'Step was successfully deleted'

    respond_to do |format|
      format.html { redirect_to(steps_url) }
      format.xml  { head :ok }
    end
  end

  def csv_import 
    @parsed_file=CSV.parse(params[:dump][:file].read)
    n=0
    @parsed_file.each  do |row|
      c=Step.new
      c.rec_date=row[0]
      c.steps=row[1]
      c.mod_steps=row[2]
      c.mod_min=row[3]
      c.user_id = current_user.id

      if c.save
        n=n+1
        GC.start if n%50==0
      end
      flash[:notice]="CSV Import Successful,  #{n} new records added to data base"
    end
    redirect_to :action=>"index"
  end

  private

  def step_params
    params.require(:step).permit(:rec_date, :steps, :mod_steps, :mod_min)
  end
end
