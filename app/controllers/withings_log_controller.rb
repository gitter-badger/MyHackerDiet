class WithingsLogController < ApplicationController
  def index
    @logs = WithingsLog.where("userid = ?", current_user.withings_userid).order('sdate DESC').limit(50)
    @withings_logs = Withings.where("userid = ?", current_user.withings_userid).order('rec_date DESC').limit(50)

    respond_to do |format|
      format.html
    end
  end

end
