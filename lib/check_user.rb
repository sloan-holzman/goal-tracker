module CheckUser

  def check_user
    if !User.find_by_id(params[:user_id])
      flash[:notice] = "Sorry, only the appropriate user can view that page"
      redirect_back fallback_location: root_path
    elsif current_user != User.find(params[:user_id])
      flash[:notice] = "Sorry, only the appropriate user can view that page"
      redirect_back fallback_location: root_path
    end
  end


end
