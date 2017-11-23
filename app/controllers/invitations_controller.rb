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


  private
  def invitation_params
    params.require(:invitation).permit(:email)
  end

end
