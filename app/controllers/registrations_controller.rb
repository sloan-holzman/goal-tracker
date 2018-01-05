class RegistrationsController < Devise::RegistrationsController
  # learned how to update users from: https://jacopretorius.net/2014/03/adding-custom-fields-to-your-devise-user-model-in-rails-4.html

  private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :reminder, :reminder_frequency, :reminder_day, :last_date_created, :last_date_entered)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :reminder, :reminder_frequency, :reminder_day)
  end
end
