class RequestsController < ApplicationController
  before_action :authenticate_user!


  def all
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

  def create
    @group = Group.find(params[:group_id])
    Request.create(user: current_user, group: @group)
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
