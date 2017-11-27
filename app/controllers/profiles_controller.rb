class ProfilesController < ApplicationController

  def show
    @user = current_user
    if @user.reminder_frequency == "Weekly"
      @message = "Every #{@user.reminder_day}"
    else
      @message = "Daily"
    end
  end

end
