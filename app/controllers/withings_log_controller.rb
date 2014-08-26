class WithingsLogController < ApplicationController
  def index
    @logs = WithingsLog.where(:user_id == current_user.withings_userid).order('sdate DESC')
    @withings_logs = Withings.where(:user_id == current_user.withings_userid).order('rec_date DESC').limit(200)

    respond_to do |format|
      format.html
    end
  end

end
