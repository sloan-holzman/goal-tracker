desc "This task is called by the Heroku scheduler add-on"
task send_weekly_reminders: :environment do
  for user in User.all
    if user.reminder
      if user.reminder_frequency == 'Daily' || user.reminder_day == Time.now.strftime("%A")
        GoalMailer.reminder_email(user).deliver
        puts "#{user.email} reminded!"
      else
        puts "#{user.email} not reminded!"
      end
    end
  end
end

task create_daily_performances: :environment do
  for metric in Metric.all
    if metric.performances.exists?(date: Date.today)
      puts "exists"
    else
      puts "doesn't exist"
      metric.performances.create!(date: Date.today, count: 0, entered: false)
    end
  end
end
