class GroupsController < ApplicationController
  before_action :authenticate_user!
  include GraphMaker

  def index
    @groups = current_user.groups
    @your_requests = current_user.requests
    @admin_memberships = current_user.memberships.where(admin: true)
    @your_invitations = Invitation.where(email: current_user.email)
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
    @group = Group.find(params[:id])
    @group_week_data = []
    @members = member_list(@group.users)
    for user in @group.users
      week_data = create_data_for_current_week_graph(user.metrics)
      @group_week_data.push(week_data)
    end
    @membership = Membership.find_by(group: @group, user: current_user)
  end

  def all
    @groups = Group.all.where(private: false) - current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @user = current_user
    @group = Group.create(group_params)
    Membership.create(user: current_user, group: @group, admin: true)
    flash[:notice] = "Group #{@group.name} created successfully"
    GoalMailer.new_group_email(@user, @group).deliver
    redirect_to user_groups_path(current_user)
  end

  def destroy
    @group = Group.find(params[:id])
    flash[:notice] = "Group #{@group.name} deleted successfully"
    @group.destroy
    redirect_to user_groups_path(current_user)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    flash[:notice] = "Group #{@group.name} updated successfully"
    redirect_to user_group_path(current_user,@group)
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
