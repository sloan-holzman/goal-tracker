class ProfilesController < ApplicationController
  include CheckUser
  before_action :authenticate_user!

  def show
    @user = current_user
    @reminder_frequency_message = current_user.find_reminder_frequency
  end

end
