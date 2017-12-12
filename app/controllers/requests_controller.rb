class RequestsController < ApplicationController
  include CheckUser
  before_action :authenticate_user!
  before_action :check_user, except: [:all, :approve, :reject]

  def all
    @user = current_user
    @approval_requests = @user.find_approval_requests
  end

  def create
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    Request.find_or_create_by!(user: @user, group: @group)
    flash[:notice] = "Your request to join group #{@group.name} has been sent"
    redirect_to request_all_path
  end

  def approve
    # update later to have a form to allow for creating admins
    @request = Request.find(params[:id])
    @user = @request.user
    @group = @request.group
    Membership.create(user: @user, group: @group, admin: false)
    flash[:notice] = "#{@user.email} was successfully added to group #{@group.name}"
    @request.destroy
    redirect_to request_all_path
  end

  def reject
    @request = Request.find(params[:id])
    flash[:notice] = "Request was successfully rejected"
    @request.destroy
    redirect_to request_all_path
  end

end
