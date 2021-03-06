require 'test_helper'

class ExampleMailer < ActionMailer::Base
  default from: "sloan.holzman@gmail.com"

  def group_email(user, group)
    @user = user
    @group = group
    mail(to: @user.email, subject: "Group '#{@group.name}' created!")
  end
end
