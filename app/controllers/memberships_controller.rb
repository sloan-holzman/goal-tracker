class MembershipsController < ApplicationController
  include CheckUser
  before_action :authenticate_user!, :check_user

  def destroy
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    @membership = Membership.find_by(user: @user, group: @group)
    @membership.destroy
    flash[:notice] = "You successfully left the group #{@group.name}"
    @group.admin_reassign
    redirect_to user_groups_path(@user)
  end
end
