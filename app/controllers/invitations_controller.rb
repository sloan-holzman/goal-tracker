class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id])
    @invitation = Invitation.create(invitation_params.merge(group: @group))
    redirect_to user_group_path(current_user,@group)
  end

  def accept
    @invitation = Invitation.find(params[:id])
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    Membership.create(user: @user, group: @group, admin: false)
    @invitation.destroy
    redirect_to user_group_path(current_user,@group)
  end

  def reject
    # must define request and add a redirect_to
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    redirect_to user_groups_path(current_user)
  end

  private
  def invitation_params
    params.require(:invitation).permit(:email)
  end

end
