class CompetitionsController < ApplicationController

  def new
    @user = current_user
    @group = Group.find(params[:group_id])
    @competition = Competition.new
  end

  def create
    @user = current_user
    @group = Group.find(params[:group_id])
    @competition = Competition.create(competition_params.merge(group: @group))
    for user in @group.users
      user.metrics.find_or_create_by!(name: @competition.metric_name, unit: @competition.metric_unit)
    end
    flash[:notice] = "Competition for #{@competition.metric_name} created successfully"
    redirect_to user_group_path(@user, @group)
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @user = current_user
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:id])
    @competion.update(competition_update_params)
    flash[:notice] = "Competition for #{@competition.metric_name} updated successfully"
    redirect_to user_group_path(@user, @group)
  end

  def show
    @user = current_user
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:id])
    running_totals = []
    for user in @group.users
      metric = user.metrics.find_by(name: @competition.metric_name, unit: @competition.metric_unit)
      running_total = metric.performances.where("date >= ? AND date <= ?", @competition.start_date, @competition.end_date).sum(:count)
      user_total = { name: "#{user.first_name} #{user.last_name}", total: running_total }
      running_totals.push(user_total)
    end
    @running_totals = running_totals.sort_by{|hash| hash[:total]}.reverse
  end

  private
  def competition_params
    params.require(:competition).permit(:metric_name, :metric_unit, :start_date, :end_date)
  end

  def competition_update_params
    params.require(:competition).permit(:start_date, :end_date)
  end

end
