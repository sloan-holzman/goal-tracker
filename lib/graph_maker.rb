module GraphMaker
  def create_data_for_line_graph(metrics)
    all_data = []
    for metric in metrics
      if Date.today >= metric.start_date
        performances = metric.performances
        set = {name: metric.name,data: performances.where("date >= ?",metric.start_date).group_by_day(:date).sum(:count)}
        all_data.push(set)
      end
    end
    return all_data
  end


  #
  # create_data_for_current_week_graph(metrics: array of hashes)
  #
  # target data is the goal/target for each metric (e.g. run 15 miles) and then actual data is how much we have done this week (e.g. only ran 10)
  # These are then put into an array which is used to create a bar graph
  # unfortunately, have to use a nested loop because the data must be organized in a very specific fashion for the chartkick graphing gem to work
  def create_data_for_current_week_graph(metrics)

    # array containing the weekly goal/target for each metric
    target_data = []
    for metric in metrics
      array = [metric.name, metric.target]
      target_data.push(array)
    end

    # array containing the current week's total for each metric
    actual_data = []
    for metric in metrics
      weekly_count = calculate_current_week_total(metric)
      array = [metric.name, weekly_count]
      actual_data.push(array)
    end

    # data organized in a manner that the chartkick gem can handle to produce bar charts for each metric's weekly total against the weekly goal
    return [{name: "Weekly Goal",data: target_data},{name: "Count so far",data: actual_data}]
  end

  #
  # calculate_current_week_total(metric: hash)
  #
  # for an invidividual metric (e.g. Running), total how much the user has done in the current week so far (e.g. 10 miles)
  def calculate_current_week_total(metric)
    weekly_count = 0
    for performance in metric.performances
      if performance.date >= Date.today.beginning_of_week(:sunday) && performance.date < (Date.today.beginning_of_week(:sunday)+7)
        weekly_count += performance.count
      end
    end
    return weekly_count
  end

  #
  # calculate_day_streak(metrics: array of hashes)
  #
  # returns an array of all the metrics and the streak total where the user has performed more than two days in a row
  def calculate_day_streak(metrics)
    day_streaks = []

    for metric in metrics

      if metric.start_date <= Date.today
        duration = Date.today - metric.start_date + 1
        streak = 0

        (1..duration).each do |i|

          if metric.performances.find_by(date: (Date.today - i)) == nil
            break
          end

          if (metric.good && metric.performances.find_by(date: (Date.today - i)).count > 0) || (metric.good == false && metric.performances.find_by(date: (Date.today - i)).count == 0)
            streak += 1
          else
            break
          end

        end

        if streak >= 2
          day_streaks.push([metric, streak])
        end

      end

    end


    return day_streaks
  end

  #
  # create_table_of_weekly_performances(metrics: array of hashes, dates: array of dates)
  #
  def create_table_of_weekly_performances(metrics, dates)
    rows = []
    for metric in metrics
      row = []
      performances = metric.performances.select {|performance| performance.date >= metric.start_date}
      sorted_performances = performances.sort_by { |performance| performance[:date] }
      for date in dates
        weekly_count = 0
        for performance in sorted_performances
          if performance.date >= date && performance.date < (date+7)
            weekly_count += performance.count
          end
        end
        if (date+6)<metric.start_date
          row.push("")
        else
          row.push(weekly_count)
        end
        weekly_count = 0
      end
      rows.push(row)
    end
    return rows
  end

  #
  # calculate_week_streak(metrics: array of hashes, rows: an array of the weekly totals for each metric)
  #
  # loops through the weekly totals for each metric and checks if it's greater than the weekly goal
  # returns an array of all the metrics and the streak total where the user has exceeded the goal for more than two weeks in a row
  def calculate_week_streak(metrics, rows)
    week_streaks = []
    metric_index = 0
    for metric in metrics
      week_streak = 0
      weeks = rows[metric_index].length - 1
      (1..weeks).each do |weeks_back|
        if (metric.good && rows[metric_index][weeks - weeks_back].to_i >= metric.target) || (metric.good == false && rows[metric_index][weeks - weeks_back].to_i <= metric.target)
          week_streak += 1
        else
          break
        end
      end
      if week_streak >= 2
        week_streaks.push([metric, week_streak])
      end
      metric_index += 1
    end
    return week_streaks
  end

  #
  # create_array_of_weeks(metrics: array of hashes)
  #
  # returns an array of the first sunday of the month for up to the last ten weeks (or dating back to the earliest start date for any of the metrics)
  def create_array_of_weeks(metrics)
    start_dates = []
    for metric in metrics
      start_dates.push(metric.start_date)
    end
    start = [start_dates.min.beginning_of_week(:sunday),(Date.today - 63).beginning_of_week(:sunday)].max
    last = Date.today.end_of_week(:saturday)
    dates = []
    day = start
    while day <= last
      dates.push(day)
      day +=7
    end
    return dates
  end


end
