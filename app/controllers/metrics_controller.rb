class MetricsController < ApplicationController
  include GraphMaker
  include CheckUser

  before_action :authenticate_user!
  before_action :check_user, except: [:all]
  # load_and_authorize_resource

  def all
    if current_user
      redirect_to user_metrics_path(current_user)
    else
      flash[:notice] = "You need to sign in or sign up before continuing."
      redirect_to new_user_session_path()
    end

  end

  def index
    @user = User.find(params[:user_id])
    @performances = @user.performances
    @metrics = @user.metrics
    if @metrics.length > 0
      @day_streaks = calculate_day_streak(@metrics)
      @all_data = create_data_for_line_graph(@metrics)
      @week_data = create_data_for_current_week_graph(@metrics)
      @dates = create_array_of_weeks(@metrics)
      @rows = create_table_of_weekly_performances(@metrics, @dates)
      @week_streaks = calculate_week_streak(@metrics, @rows)
    end
  end

  def new
    @user = User.find(params[:user_id])
    @metric = @user.metrics.new
  end

  def show
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:id])
    @performances = @metric.performances
    @daily_data = [{name: @metric.name,data: @performances.where("date >= ?",@metric.start_date).group_by_day(:date).sum(:count)}]
    @weekly_data = [{name: @metric.name,data: @performances.where("date >= ?",@metric.start_date).group_by_week(:date).sum(:count)}]
  end

  def create
    @user = User.find(params[:user_id])
    @metric = @user.metrics.create!(metric_params)
    # automatically create performances for every day since the start date
    if Date.today > @metric.start_date
      (@metric.start_date..Date.today).each do |date|
        @metric.performances.create!(count: 0, date: date, entered: false)
      end
    end
    flash[:notice] = "Goal #{@metric.name} created successfully"
    redirect_to user_metric_path(@user,@metric)
  end

  def edit
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:id])
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
    redirect_to user_metric_path(@user,@metric)
  end

  def destroy
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:id])
    flash[:notice] = "Goal #{@metric.name} deleted successfully"
    @metric.destroy
    redirect_to user_metrics_path(@user)
  end

  private
  def metric_params
    params.require(:metric).permit(:name, :unit, :target, :good, :duration, :start_date)
  end

end
