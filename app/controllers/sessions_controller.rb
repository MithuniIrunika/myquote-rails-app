class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)

    if user && user.authenticate(params[:password])
      if user.status != "Active"
        flash.now[:error] = "Your account is #{user.status}. Please contact an administrator."
        render :new, status: :unprocessable_entity
        return
      end

      session[:user_id]  = user.id
      session[:fname]    = user.fname
      session[:is_admin] = user.is_admin

      if user.is_admin
        redirect_to admin_path, notice: "Welcome back, #{user.fname}! You are signed in as administrator."
      else
        redirect_to userhome_path, notice: "Welcome back, #{user.fname}! You are now signed in."
      end
    else
      flash.now[:error] = "Invalid email or password. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "You have been signed out successfully."
  end
end