class GoalMailer < ActionMailer::Base
  default from: "sloan.holzman@gmail.com"

  def new_group_email(user, group)
    @user = user
    @group = group
    mail(to: @user.email, subject: "Group '#{@group.name}' created!")
  end

  def reminder_email(user)
    @user = user
    @unentered_performances = @user.performances.where(entered: false)
    @number_unentered = @unentered_performances.length
    mail(to: @user.email, subject: "You have '#{@number_unentered}' performances to enter!")
  end

end


# used https://launchschool.com/blog/handling-emails-in-rails to make this
