class MetricsController < ApplicationController
  before_action :authenticate_user!
  # , :except => [:show, :index]
  # load_and_authorize_resource

  def index
    @performances = current_user.performances
    @metrics = current_user.metrics
    @day_streaks = calculate_day_streak(@metrics)
    @all_data = create_date_for_line_graph(@metrics)
    @week_data = create_data_for_current_week_graph(@metrics)
    @dates = create_array_of_weeks(@metrics)
    @rows = create_table_of_weekly_performances(@metrics, @dates)
    @week_streaks = calculate_week_streak(@metrics, @rows)
  end

  def new
    @metric = current_user.metrics.new
  end

  def show
    @metric = current_user.metrics.find(params[:id])
    @performances = @metric.performances
    @all_data = [{name: @metric.name,data: @performances.group_by_day(:date).sum(:count)}]
  end

  def create
    @metric = current_user.metrics.create!(metric_params)
    # automatically create performances for every day since the start date
    if Date.today > @metric.start_date
      (@metric.start_date..Date.today).each do |date|
        @metric.performances.create!(count: 0, date: date, entered: false)
      end
    end
    flash[:notice] = "Goal #{@metric.name} created successfully"
    redirect_to user_metric_path(current_user,@metric)
  end

  def edit
    @metric = current_user.metrics.find(params[:id])
  end

  def update
    @metric = current_user.metrics.find(params[:id])
    @metric.update(metric_params)
    # automatically create performances for every day since the start date
    if Date.today > @metric.start_date
      (@metric.start_date..Date.today).each do |date|
        if !@metric.performances.exists?(date: date)
          @metric.performances.create!(count: 0, date: date, entered: false)
        end
      end
    end
    # if there are old, unentered performances from before the start date, just delete them
    for performance in @metric.performances
      if performance.date < @metric.start_date && performance.entered == false
        performance.destroy!
      end
    end
    flash[:notice] = "Goal #{@metric.name} updated successfully"
    redirect_to user_metric_path(current_user,@metric)
  end

  def destroy
    @metric = current_user.metrics.find(params[:id])
    flash[:notice] = "Goal #{@metric.name} deleted successfully"
    @metric.destroy
    redirect_to root_path
  end

  private
  def metric_params
    params.require(:metric).permit(:name, :unit, :target, :good, :duration, :start_date)
  end

  def create_date_for_line_graph(metrics)
    all_data = []
    for metric in metrics
      if Date.today >= metric.start_date
        performances = metric.performances
        set = {name: metric.name,data: performances.group_by_day(:date, week_start: metric.start_date).sum(:count)}
        all_data.push(set)
      end
    end
    return all_data
  end

  def create_data_for_current_week_graph(metrics)
    # target data is the goal/target for each metric and then actual data is how much we have done this week.
    # These are then put into an array called @week_data which can be fed into a graph
    target_data = []
    for metric in metrics
      array = [metric.name, metric.target]
      target_data.push(array)
    end
    actual_data = []
    for metric in metrics
      weekly_count = 0
      for performance in metric.performances
        if performance.date >= Date.today.beginning_of_week(:sunday) && performance.date < (Date.today.beginning_of_week(:sunday)+7)
          weekly_count += performance.count
        end
      end
      array = [metric.name, weekly_count]
      actual_data.push(array)
      weekly_count = 0
    end
    return [{name: "Weekly Goal",data: target_data},{name: "Count so far",data: actual_data}]
  end

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

  def calculate_week_streak(metrics, rows)
    week_streaks = []
    metric_index = 0
    for metric in metrics
      week_streak = 0
      weeks = rows[metric_index].length - 1
      (1..weeks).each do |weeks_back|
        if rows[metric_index][weeks - weeks_back].to_i >= metric.target
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

  def create_array_of_weeks(metrics)
    start_dates = []
    for metric in metrics
      start_dates.push(metric.start_date)
    end
    start = start_dates.min.beginning_of_week(:sunday)
    last = Date.today.end_of_week(:saturday)
    dates = []
    day = start
    while day <= last
      dates.push(day)
      day +=7
    end
    return dates
  end

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

end
