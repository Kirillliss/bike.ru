class UsersController < BaseController

  def show
    if current_user
    else
      redirect_to new_user_session_path
    end
  end

end
