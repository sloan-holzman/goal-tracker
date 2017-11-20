class PerformancesController < ApplicationController
  before_action :authenticate_user!
  # , :except => [:show, :index]
  # load_and_authorize_resource

  def show
    @metric = current_user.metrics.find(params[:metric_id])
    @performance = Performance.find(params[:id])
  end

  def new
    @metric = current_user.metrics.find(params[:metric_id])
    @performance = @metric.performances.new
  end

  def create
    @metric = current_user.metrics.find(params[:metric_id])
    @performance = @metric.performances.create!(performance_params.merge(entered: true))
    redirect_to user_metric_performance_path(current_user,@metric, @performance)
  end

  def edit
    @metric = current_user.metrics.find(params[:metric_id])
    @performance = Performance.find(params[:id])
  end

  def update
    @metric = current_user.metrics.find(params[:metric_id])
    @performance = @metric.performances.update(performance_params.merge(entered: true))
    redirect_to user_metric_performance_path(current_user,@metric, @performance)
  end

  def destroy
    @metric = current_user.metrics.find(params[:metric_id])
    @performance = Performance.find(params[:id])
    @performance.destroy
    redirect_to user_metric_path(current_user, @metric)
  end

  # def create_all
  #   for metric in Metric.all
  #     metric.performances.create!(date: Date.today, count: 0)
  #   end
  # end

  private
  def performance_params
    params.require(:performance).permit(:date, :count)
  end

end
