# used https://launchschool.com/blog/handling-emails-in-rails to figure this out


class GoalMailer < ActionMailer::Base
  default from: "goaltracker2000@gmail.com"

  def new_group_email(user, group)
    @user = user
    @group = group
    mail(to: @user.email, subject: "Group '#{@group.name}' created!")
  end

  def invitation_email(user, group, email)
    @user = user
    @group = group
    @email = email
    mail(to: @email, subject: "You were invited to join Accountability Group '#{@group.name}'")
  end

  # def reminder_email(user)
  #   @user = user
  #   @metrics = @user.metrics
  #   if @metrics.length == 0
  #     mail(to: @user.email, subject: "You haven't set any goals yet.  Follow link to start")
  #   else
  #     @unentered_performances = @user.performances.where(entered: false)
  #     @number_unentered = @unentered_performances.length
  #     @unentered_dates = []
  #     @weekly_totals = []
  #     @days_remaining = ((Date.today.beginning_of_week(:sunday)+7) - Date.today).to_i
  #     for metric in @metrics
  #       weekly_count = 0
  #       for performance in metric.performances
  #         if performance.date >= Date.today.beginning_of_week(:sunday) && performance.date < (Date.today.beginning_of_week(:sunday)+7)
  #           weekly_count += performance.count
  #         end
  #       end
  #       @weekly_totals.push(weekly_count)
  #     end
  #     if @number_unentered > 0
  #       for performance in @unentered_performances
  #           @unentered_dates.push(performance.date)
  #       end
  #       @unentered_dates = @unentered_dates.uniq
  #       @unentered_dates.sort!
  #       if @number_unentered == 1
  #         mail(to: @user.email, subject: "Please enter your daily performance for #{@unentered_dates[0]}")
  #       else
  #         mail(to: @user.email, subject: "Please enter your daily performance for #{@unentered_dates.length} days")
  #       end
  #     else
  #       mail(to: @user.email, subject: "Just #{@days_remaining} days left in the week.  Keep it up!")
  #     end
  #   end
  # end

  def reminder_email(user)
    @user = user
    @metrics = @user.metrics.where("start_date < ?",(Date.today.beginning_of_week(:sunday)+7))
    @days_remaining = ((Date.today.beginning_of_week(:sunday)+7) - Date.today).to_i
    if @metrics.length == 0
      mail(to: @user.email, subject: "You haven't set any goals yet.  Follow link to start")
    else
      @number_unentered = (Date.today - @user.last_date_entered).to_i
      if @number_unentered > 0
        @unentered_dates = []
        date = Date.today
        while date > @user.last_date_entered
          @unentered_dates.push(date)
          date -=1
        end
        mail(to: @user.email, subject: "Please enter your daily performance for the last #{@number_unentered} days")
      else
        mail(to: @user.email, subject: "Just #{@days_remaining} days left in the week.  Keep it up!")
      end
    end
  end




end
