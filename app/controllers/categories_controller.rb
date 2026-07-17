class CategoriesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.order(:catname)
  end

  def show
    @quotes = if is_administrator?
                @category.quotes.includes(:user, :philosopher).recent
              elsif logged_in?
                @category.quotes.includes(:user, :philosopher)
                                .where("ispublic = ? OR user_id = ?", true, current_user.id).recent
              else
                @category.quotes.includes(:user, :philosopher).public_quotes.recent
              end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category added successfully."
      redirect_to categories_path
    else
      flash.now[:error] = "Could not add category. Please correct the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category updated successfully."
      redirect_to categories_path
    else
      flash.now[:error] = "Update failed. Please correct the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Category deleted successfully."
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find_by(id: params[:id])
    unless @category
      flash[:error] = "Category not found."
      redirect_to categories_path
    end
  end

  def category_params
    params.require(:category).permit(:catname)
  end
end