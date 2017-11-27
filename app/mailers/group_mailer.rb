class GroupMailer < ActionMailer::Base
  default from: "sloan.holzman@gmail.com"

  def group_email(user, group)
    @user = user
    @group = group
    mail(to: @user.email, subject: "Group '#{@group.name}' created!")
  end
end


# used https://launchschool.com/blog/handling-emails-in-rails to make this
