class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    if is_administrator?
      @users = User.order(:lname, :fname)
    else
      flash[:error] = "You are not authorised to access this resource."
      redirect_to userhome_path
    end
  end

  def show
    unless is_administrator? || current_user.id == @user.id
      flash[:error] = "You are not authorised to view this user."
      redirect_to(userhome_path) and return
    end
  end

  def new
    @user = User.new
  end

  def edit
    unless is_administrator? || current_user.id == @user.id
      flash[:error] = "You are not authorised to edit this user."
      redirect_to(userhome_path) and return
    end
  end

  def create
    @user = User.new(user_params_signup)
    @user.is_admin = false
    @user.status   = "Active"

    if @user.save
      flash[:notice] = "Sign up successful! Please log in to start using MyQuote."
      redirect_to login_path
    else
      flash.now[:error] = "Sign up failed. Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    allowed = if is_administrator? && current_user.id != @user.id
                user_params_admin
              elsif current_user.id == @user.id
                user_params_self
              else
                {}
              end

    if allowed[:password].blank?
      allowed = allowed.except(:password, :password_confirmation)
    end

    if @user.update(allowed)
      flash[:notice] = "User details updated successfully."
      redirect_to(is_administrator? ? users_path : userhome_path)
    else
      flash.now[:error] = "Update failed. Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless is_administrator?
      flash[:error] = "You are not authorised to delete users."
      redirect_to(userhome_path) and return
    end

    if @user.id == current_user.id
      flash[:error] = "You cannot delete your own account while signed in."
      redirect_to users_path and return
    end

    deleted_name = @user.full_name
    @user.destroy
    flash[:notice] = "User #{deleted_name} has been deleted along with all their quotes."
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:error] = "User not found."
      redirect_to(is_administrator? ? users_path : userhome_path)
    end
  end

  def user_params_signup
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
  end

  def user_params_self
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
  end

  def user_params_admin
    params.require(:user).permit(:status, :is_admin)
  end
end