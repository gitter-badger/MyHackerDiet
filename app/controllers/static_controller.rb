class StaticController < ApplicationController
  def about
  end

  def show
  end

  def edit
  end

  def index
  end

  def home
    if current_user

      # Weight summary information
      begin
        @current_weight = Weight.find_by_user_id(current_user.id, :order => 'rec_date DESC')
        @one_week_ago_weight = Weight.find_by_user_id( current_user.id, :conditions => ['rec_date >= ?', 7.days.ago] )

        @last_weighin_days = (Date.today - @current_weight.rec_date).to_i
        @current_diff = (@current_weight.avg_weight - @one_week_ago_weight.avg_weight).to_f
      rescue
        @current_weight = 0
        @one_week_ago_weight = 0
        @last_weighin_days = 0
        @current_diff = 0
      end

        @graph_week = current_user.graph_code( 'Last Week', 1.week.ago, '400x150' )
        @graph_two_weeks = current_user.graph_code( 'Last 2 Weeks', 2.weeks.ago, '400x150' )
        @graph_two_months = current_user.graph_code( 'Last 2 Months', 2.months.ago, '400x150' )
        @graph_three_months = current_user.graph_code( 'Last 3 Months', 3.months.ago, '400x150' )

        @graph_week_big = current_user.graph_code( 'Last Week', 1.week.ago, '800x300' )
        @graph_two_weeks_big = current_user.graph_code( 'Last 2 Weeks', 2.weeks.ago, '800x300' )
        @graph_two_months_big = current_user.graph_code( 'Last 2 Months', 2.months.ago, '800x300' )
        @graph_three_months_big = current_user.graph_code( 'Last 3 Months', 3.months.ago, '800x300' )

      # Step summary information
      begin
        @steps_7_days = Step.average(:steps, :conditions => ['user_id = ?', current_user.id], :limit => 7, :order => 'rec_date DESC')

        steps_months_sql = "select year(rec_date) as year, month(rec_date) as month, sum(steps) as steps, sum(mod_steps) as mod_steps, sum(mod_min) as mod_min from steps where user_id = #{current_user.id} and month(rec_date) is not null group by year(rec_date), month(rec_date) limit 365"
        @steps_months = Step.connection.select_all(steps_months_sql)
      rescue
        @steps_7_days = 0
        @steps_months = 0
      end

      render :home_user
    end
  end

end

