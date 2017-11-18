class MetricsController < ApplicationController
  before_action :authenticate_user!
  # , :except => [:show, :index]
  # load_and_authorize_resource

  def index
    @metrics = current_user.metrics
    # problem!  performances includes them all...need to only include by metric
    # performances = []
    start = Date.today
    last = Date.parse('2001-01-01')
    for metric in @metrics
      for performance in metric.performances
        # performances.push(performance)
        if performance.date < start
          start = performance.date
        end
        if performance.date > last
          last = performance.date
        end
      end
    end
    # @performances = performances.sort_by { |performance| performance[:date] }
    @start = start.beginning_of_week(:sunday)
    @last = [last.end_of_week(:saturday),Date.today].min
    dates = []
    day = @start
    while day < @last
      dates.push(day)
      day +=7
    end
    @dates = dates
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
