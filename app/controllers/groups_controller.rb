class GroupsController < ApplicationController
  include GraphMaker
  include CheckUser
  include CreatePerformances

  before_action :authenticate_user!
  before_action :check_user, except: [:all]
  before_action :create_old_performances, except: [:index, :all, :new, :create, :edit, :update, :destroy]


  def index
    @user = User.find(params[:user_id])
    @groups = @user.groups
    @your_requests = @user.requests
    @your_invitations = Invitation.where(email: @user.email)
    @approval_requests = @user.find_approval_requests
  end

  def show
    if !Group.find_by_id(params[:id]) || current_user != User.find(params[:user_id])
      flash[:notice] = "Sorry, no such group exists"
      redirect_back fallback_location: root_path
    else
      @user = User.find(params[:user_id])
      @group = Group.find(params[:id])
      @members = @group.users.map {|member| "#{member.first_name} #{member.last_name}"}
      @group_week_data = {}
      @group_dates = {}
      @table_array = {}
      @group.users.each do |user|
        if user.metrics.length > 0
          @group_week_data[user.id] = user.create_data_for_current_week_graph
          @table_array[user.id] = user.create_metric_table
        end
      end
      @membership = Membership.find_by(group: @group, user: @user)
    end
  end

  def all
    @groups = Group.all.where(private: false) - current_user.groups
  end

  def new
    @user = User.find(params[:user_id])
    @group = Group.new
  end

  def create
    @user = User.find(params[:user_id])
    @group = Group.create(group_params)
    Membership.create(user: @user, group: @group, admin: true)
    flash[:notice] = "Group #{@group.name} created successfully"
    GoalMailer.new_group_email(@user, @group).deliver
    redirect_to user_groups_path(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
    flash[:notice] = "Group #{@group.name} deleted successfully"
    @group.destroy
    redirect_to user_groups_path(@user)
  end

  def edit
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
    @group.update(group_params)
    flash[:notice] = "Group #{@group.name} updated successfully"
    redirect_to user_group_path(@user,@group)
  end

  private
  def group_params
    params.require(:group).permit(:name, :private)
  end


end
