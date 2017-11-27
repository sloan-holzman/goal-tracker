desc 'create daily performances'
task create_daily_performances: :environment do
  for metric in Metric.all
    metric.performances.create!(date: Date.today, count: 0, entered: false)
  end
end
