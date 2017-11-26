class MembershipsController < ApplicationController
  def destroy
    @group = Group.find(params[:group_id])
    @membership = Membership.find_by(user: current_user, group: @group)
    @membership.destroy
    flash[:notice] = "You successfully left the group #{@group.name}"
    if @group.users.length == 1
      @admin = @group.users.first
      @membership = Membership.where(group: @group, user: @admin)
      @membership.update(admin: true)
    else @group.users.length == 0
      @group.destroy
    end
    redirect_to user_groups_path(current_user)
  end
end
