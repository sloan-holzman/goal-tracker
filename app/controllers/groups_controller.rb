class GroupsController < ApplicationController

  def index
    @groups = current_user.groups
  end

  def all
    @groups = Group.all
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
