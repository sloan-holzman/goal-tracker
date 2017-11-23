class RequestsController < ApplicationController
  def all
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

  def create
    # must define user and group
    @group = Group.find(params[:group_id])
    Request.create(user: current_user, group: @group, approved: false)
    redirect_to request_all_path
  end

  def approve
    # update later to have a form to allow for creating admins
    @request = Request.find(params[:id])
    @user = @request.user
    @group = @request.group
    Membership.create(user: @user, group: @group, admin: false)
    @request.destroy
    redirect_to request_all_path
  end

  def reject
    # must define request and add a redirect_to
    @request = Request.find(params[:id])
    @request.destroy
    redirect_to request_all_path
  end

end
