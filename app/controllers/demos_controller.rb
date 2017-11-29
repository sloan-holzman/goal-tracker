class DemosController < ApplicationController

  def index
    @user = current_user
    @group = Group.find(params[:group_id])
    @competition = Competition.new
  end

end
