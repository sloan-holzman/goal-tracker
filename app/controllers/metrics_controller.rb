class MetricsController < ApplicationController
  before_action :authenticate_user!
  include GraphMaker
  # load_and_authorize_resource

  def index
    @performances = current_user.performances
    @metrics = current_user.metrics
    @day_streaks = calculate_day_streak(@metrics)
    @all_data = create_data_for_line_graph(@metrics)
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
    @daily_data = [{name: @metric.name,data: @performances.where("date >= ?",@metric.start_date).group_by_day(:date).sum(:count)}]
    @weekly_data = [{name: @metric.name,data: @performances.where("date >= ?",@metric.start_date).group_by_week(:date).sum(:count)}]
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
    redirect_to user_metrics_path(current_user)
  end

  private
  def metric_params
    params.require(:metric).permit(:name, :unit, :target, :good, :duration, :start_date)
  end

end
