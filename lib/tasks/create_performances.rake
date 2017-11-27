desc 'create daily performances'
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
