module CheckUser

  def check_user
    if !current_user
      flash[:notice] = "#{User.find(params[:user_id])}"
      redirect_to user_session_path()
    elsif !User.find_by_id(params[:user_id])
      flash[:notice] = "Sorry, only the appropriate user can view that page"
      redirect_to root_path()
    elsif current_user != User.find(params[:user_id])
      flash[:notice] = "Sorry, only the appropriate user can view that page"
      redirect_to root_path()
    end
  end


end
