class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :is_administrator?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def is_administrator?
    logged_in? && current_user.is_admin
  end

  private

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this resource."
      redirect_to login_path
    end
  end

  def require_admin
    unless is_administrator?
      flash[:error] = "You are not authorised to access this resource."
      redirect_to(logged_in? ? userhome_path : login_path)
    end
  end
end