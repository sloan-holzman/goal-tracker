desc 'send weekly reminders'
task send_weekly_reminders: :environment do
  for user in User.all
    if user.reminder
      GoalMailer.reminder_email(user).deliver
    end
  end
end
