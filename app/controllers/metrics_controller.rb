class MetricsController < ApplicationController
  include GraphMaker
  include CheckUser
  include CreatePerformances

  before_action :authenticate_user!
  before_action :check_user, except: [:all]
  before_action :create_old_performances, except: [:all, :new, :create, :edit, :update, :destroy]


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
      @all_data = create_data_for_line_graph(@metrics)
      @week_data = create_data_for_current_week_graph(@metrics)
      @table_array = @user.create_metric_table
      @dates = create_array_of_weeks(@metrics)
      # @rows = create_table_of_weekly_performances(@metrics, @dates)
      # @week_streaks = calculate_week_streak(@metrics, @rows)
      @week_streaks = calculate_week_streak(@metrics)
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
    @metric = @user.metrics.create!(metric_params.merge(last_day_undone: (metric_params[:start_date].to_date - 1), last_week_undone: metric_params[:start_date].to_date.beginning_of_week(:sunday)))
    @metric.create_old_performances
    @metric.create_past_weekly_totals
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
    original_start_date = @metric.start_date
    @metric.update(metric_params)
    @metric.create_old_performances
    @metric.update_weekly_totals(original_start_date)
    @metric.find_last_day_undone
    @metric.delete_prestart_unentered_performances
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
