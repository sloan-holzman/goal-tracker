class CompetitionsController < ApplicationController
  include CheckUser
  before_action :authenticate_user!, :check_user

  def new
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @competition = Competition.new
  end

  def create
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @competition = Competition.create(competition_params.merge(group: @group))
    if @competition.valid?
      @competition.create_user_metrics
      flash[:notice] = "Competition for #{@competition.metric_name} created successfully"
    else
      flash[:notice] = "Woops, something went wrong"
    end
    redirect_to user_group_path(@user, @group)
  end

  def edit
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:id])
    @competition.update(competition_update_params)
    flash[:notice] = "Competition for #{@competition.metric_name} updated successfully"
    redirect_to user_group_competition_path(@user, @group, @competition)
  end

  def show
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:id])
    @running_totals = @competition.create_running_totals
  end

  def destroy
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @competition = Competition.find(params[:id])
    flash[:notice] = "Competition for #{@competition.metric_name} deleted successfully"
    @competition.destroy
    redirect_to user_group_path(@user, @group)
  end

  private
  def competition_params
    params.require(:competition).permit(:metric_name, :metric_unit, :start_date, :end_date)
  end

  def competition_update_params
    params.require(:competition).permit(:start_date, :end_date)
  end

end
