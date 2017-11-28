desc "This task is called by the Heroku scheduler add-on"
task send_weekly_reminders: :environment do
  for user in User.all
    if user.reminder
      if user.reminder_frequency == 'Daily' || user.reminder_day == Time.now.strftime("%A")
        GoalMailer.reminder_email(user).deliver
      end
    end
  end
end

task create_daily_performances: :environment do
  for metric in Metric.all
    if metric.performances.exists?(date: Date.today) || metric.start_date > Date.today
      puts "DIDN'T CREATE: Metric name: #{metric.name}, Metric start date: #{metric.start_date}"
    else
      metric.performances.create!(date: Date.today, count: 0, entered: false)
      puts "CREATED: Metric name: #{metric.name}, Metric start date: #{metric.start_date}"
    end
  end
end
