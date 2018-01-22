class PerformancesController < ApplicationController
  include CheckUser
  include CreatePerformances

  before_action :authenticate_user!
  before_action :check_user, except: [:edit_all, :update_all, :edit_day, :select_day, :update_day]
  before_action :create_old_performances


  def show
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:metric_id])
    @performance = Performance.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:metric_id])
    @performance = @metric.performances.new
  end

  def create
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:metric_id])
    @performance = @metric.performances.create!(performance_params.merge(entered: true))
    flash[:notice] = "Metric #{@metric.name} created successfully"
    redirect_to user_metric_performance_path(@user,@metric, @performance)
  end

  def edit
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:metric_id])
    @performance = Performance.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:metric_id])
    @performance = @metric.performances.update(performance_params.merge(entered: true))
    @user.update_last_date_entered(@performance)
    flash[:notice] = "Metric #{@metric.name} updated successfully"
    redirect_to user_metric_performance_path(@user,@metric, @performance)
  end

  def destroy
    @user = User.find(params[:user_id])
    @metric = @user.metrics.find(params[:metric_id])
    @performance = Performance.find(params[:id])
    @performance.destroy
    redirect_to user_metric_path(@user, @metric)
  end

# learned edit_all and update_all from http://anthonylewis.com/2011/04/15/editing-multiple-records-in-rails/

  def edit_all
    @performances = current_user.performances.select{ |performance| performance.entered == false }.sort_by{ |performance| [performance.date, performance.metric] }
  end

# overrode authentication error by checking stackoverflow here: https://stackoverflow.com/questions/20156664/saving-multiple-records-with-params-require-in-ruby

  def update_all
    params['performance'].keys.each do |id|
      @performance = Performance.find(id.to_i)
      old_count = @performance.count
      @performance.update_attributes!(performances_params(id))
      @performance.update(entered: true)
      @performance.find_last_day_undone
      @performance.update_weekly_total(old_count)
      current_user.update_last_date_entered(@performance)
    end
    flash[:notice] = "Performances updated successfully"
    redirect_to(user_metrics_path(current_user))
  end

  def select_day
    redirect_to "/performances/#{params[:date].to_s}/edit"
  end

  def edit_day
    @metrics = current_user.metrics
    @date = params[:date].to_date
    @performances = current_user.performances.select{ |performance| performance.date == @date }
  end

  # overrode authentication error by checking stackoverflow here: https://stackoverflow.com/questions/20156664/saving-multiple-records-with-params-require-in-ruby

  def update_day
    params['performance'].keys.each do |id|
      @performance = Performance.find(id.to_i)
      old_count = @performance.count
      @performance.update_attributes!(performances_params(id))
      @performance.update(entered: true)
      @performance.update_weekly_total(old_count)
      @performance.find_last_day_undone
      current_user.update_last_date_entered(@performance)
    end
    flash[:notice] = "Performances updated successfully"
    redirect_to(user_metrics_path(current_user))
  end



  private
  def performances_params(id)
    params.require(:performance).fetch(id).permit(:count)
  end

  def performance_params
    params.require(:performance).permit(:date, :count)
  end

end
