require 'test_helper'

class ExampleMailer < ActionMailer::Base
  default from: "sloan.holzman@gmail.com"

  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
