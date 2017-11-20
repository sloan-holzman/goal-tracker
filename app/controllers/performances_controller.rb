class PerformancesController < ApplicationController
  # before_action :authenticate_user!
  # , :except => [:show, :index]
  # load_and_authorize_resource

  attr_accessor :date, :count, :entered

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

# learned edit_all and update_all from http://anthonylewis.com/2011/04/15/editing-multiple-records-in-rails/

  def edit_all
    performances = []
    for metric in current_user.metrics
      for performance in metric.performances
        performances.push(performance)
      end
    end
    @performances = performances
  end

# overrode authentication error by checking stackoverflow here: https://stackoverflow.com/questions/20156664/saving-multiple-records-with-params-require-in-ruby

  def update_all
    params['performance'].keys.each do |id|
      @performance = Performance.find(id.to_i)
      @performance.update_attributes!(performance_params(id))
    end
    redirect_to(root_url)
  end

  private
  def performance_params(id)
    params.require(:performance).fetch(id).permit(:date, :count)
  end

  def performance_params
    params.require(:performance).permit(:date, :count)
  end

end
