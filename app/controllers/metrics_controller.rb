class MetricsController < ApplicationController
  before_action :authenticate_user!
  # , :except => [:show, :index]
  # load_and_authorize_resource

  def index
    @metrics = current_user.metrics
  end

  def new
    @metric = current_user.metrics.new
  end

  def show
    @metric = current_user.metrics.find(params[:id])
  end

  def create
    @metric = current_user.metrics.create!(metric_params)
    redirect_to user_metric_path(current_user,@metric)
  end

  def edit
    @metric = current_user.metrics.find(params[:id])
  end

  def update
    @metric = current_user.metrics.find(params[:id])
    @metric.update(metric_params.merge(user: current_user))
    redirect_to user_metric_path(current_user,@metric)
  end

  def destroy
    @metric = current_user.metrics.find(params[:id])
    @metric.destroy
    redirect_to user_path(current_user)
  end

  private
  def metric_params
    params.require(:metric).permit(:name, :unit, :target, :good, :duration)
  end

end
