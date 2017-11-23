class GroupsController < ApplicationController

  def index
    @groups = current_user.groups
    @your_requests = current_user.requests
    @admin_memberships = current_user.memberships.where(admin: true)
    groups = []
    for membership in @admin_memberships
      groups.push(membership.group)
    end
    approval_requests = []
    for group in groups
      for request in group.requests
        approval_requests.push(request)
      end
    end
    if approval_requests.length > 0
      @approval_requests = approval_requests
    else
      @approval_requests = []
    end
  end

  def all
    @groups = Group.all.where(private: false) - current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @name = group_params[:name].titleize
    @group = Group.find_or_create_by(name: @name)
    if current_user.groups.find_by(name: @name)
    else
      Membership.create(user: current_user, group: @group, admin: true)
    end
    redirect_to user_groups_path(current_user)
  end

  private
  def group_params
    params.require(:group).permit(:name)
  end

end
