desc 'send weekly reminders'
task send_weekly_reminders: :environment do
  for user in User.all
    if user.reminder
      if user.reminder_frequency == 'Daily' || user.reminder_day == Time.now.strftime("%A")
        GoalMailer.reminder_email(user).deliver
      end
    end
  end
end
