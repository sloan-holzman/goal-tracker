class MembershipsController < ApplicationController
  before_action :authenticate_user!


  def destroy
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @membership = Membership.find_by(user: @user, group: @group)
    @membership.destroy
    flash[:notice] = "You successfully left the group #{@group.name}"
    if @group.users.length == 1 || @group.memberships.where(admin: true).count == 0
      @admin = @group.users.first
      @membership = Membership.where(group: @group, user: @admin)
      @membership.update(admin: true)
    else @group.users.length == 0
      @group.destroy
    end
    redirect_to user_groups_path(@user)
  end
end
