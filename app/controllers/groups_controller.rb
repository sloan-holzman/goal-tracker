class GroupsController < ApplicationController

  def index
    @groups = current_user.groups
    @your_requests = current_user.requests
    @admin_memberships = current_user.memberships.where(admin: true)
    @your_invitations = Invitation.where(email: current_user.email)
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

  def show
    @group = Group.find(params[:id])
    @group_week_data = []
    for user in @group.users
      target_data = []
      for metric in user.metrics
        array = [metric.name, metric.target]
        target_data.push(array)
      end
      actual_data = []
      for metric in user.metrics
        weekly_count = 0
        for performance in metric.performances
          if performance.date >= Date.today.beginning_of_week(:sunday) && performance.date < (Date.today.beginning_of_week(:sunday)+7)
            weekly_count += performance.count
          end
        end
        array = [metric.name, weekly_count]
        actual_data.push(array)
        weekly_count = 0
      end
      week_data = [{name: "Weekly Goal",data: target_data},{name: "Count so far",data: actual_data}]
      @group_week_data.push(week_data)
    end
    @membership = Membership.find_by(group: @group, user: current_user)
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
    flash[:notice] = "Group #{@group.name} created successfully"
    redirect_to user_groups_path(current_user)
  end

  def destroy
    @group = Group.find(params[:id])
    flash[:notice] = "Group #{@group.name} deleted successfully"
    @group.destroy
    redirect_to user_groups_path(current_user)
  end

  private
  def group_params
    params.require(:group).permit(:name)
  end

end
