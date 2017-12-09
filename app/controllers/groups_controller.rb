class GroupsController < ApplicationController
  before_action :authenticate_user!
  include GraphMaker

  def index
    @user = User.find(params[:user_id])
    @groups = @user.groups
    @your_requests = @user.requests
    @admin_memberships = @user.memberships.where(admin: true)
    @your_invitations = Invitation.where(email: @user.email)
    groups = []
    for membership in @admin_memberships
      groups.push(membership.group)
    end
    @approval_requests = []
    for group in groups
      for request in group.requests
        @approval_requests.push(request)
      end
    end
  end

  def show
    @user = User.find(params[:user_id])
    @group = Group.find(params[:id])
    @group_week_data = []
    @group_dates = []
    @group_rows = []
    @members = member_list(@group.users)
    for user in @group.users
      week_data = create_data_for_current_week_graph(user.metrics)
      @group_week_data.push(week_data)
      dates = create_array_of_weeks(user.metrics)
      @group_dates.push(dates)
      rows = create_table_of_weekly_performances(user.metrics, dates)
      @group_rows.push(rows)
    end
    @membership = Membership.find_by(group: @group, user: @user)
  end

  def all
    @groups = Group.all.where(private: false)
  end

  def new
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

  def member_list(members)
    member_list = []
    for member in members
      member_list.push("#{member.first_name} #{member.last_name}")
    end
    return member_list
  end

end
