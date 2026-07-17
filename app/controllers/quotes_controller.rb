class QuotesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  def index
    if is_administrator?
      @quotes = Quote.includes(:user, :philosopher, :categories).recent
    elsif logged_in?
      @quotes = Quote.includes(:user, :philosopher, :categories)
                     .where("ispublic = ? OR user_id = ?", true, current_user.id)
                     .recent
    else
      @quotes = Quote.includes(:user, :philosopher, :categories).public_quotes.recent
    end
  end

  def show
    if !@quote.ispublic && !is_administrator? && current_user&.id != @quote.user_id
      flash[:error] = "This quote is private and you do not have permission to view it."
      redirect_to(root_path) and return
    end
  end

  def new
    @quote = Quote.new
    3.times { @quote.quote_categories.build }
  end

  def create
    @quote = Quote.new(quote_params)
    @quote.user_id = current_user.id

    if @quote.save
      flash[:notice] = "Your quote has been added successfully."
      redirect_to quote_path(@quote)
    else
      (3 - @quote.quote_categories.size).times { @quote.quote_categories.build } if @quote.quote_categories.size < 3
      flash.now[:error] = "Could not save your quote. Please correct the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless owner_or_admin?
      flash[:error] = "You are not authorised to edit this quote."
      redirect_to(quote_path(@quote)) and return
    end
  end

  def update
    unless owner_or_admin?
      flash[:error] = "You are not authorised to edit this quote."
      redirect_to(quote_path(@quote)) and return
    end

    if @quote.update(quote_params)
      flash[:notice] = "Quote updated successfully."
      redirect_to quote_path(@quote)
    else
      flash.now[:error] = "Update failed. Please correct the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless owner_or_admin?
      flash[:error] = "You are not authorised to delete this quote."
      redirect_to(quote_path(@quote)) and return
    end

    @quote.destroy
    flash[:notice] = "Quote deleted successfully."
    redirect_to your_quotes_path
  end

  private

  def set_quote
    @quote = Quote.find_by(id: params[:id])
    unless @quote
      flash[:error] = "Quote not found."
      redirect_to root_path
    end
  end

  def owner_or_admin?
    is_administrator? || current_user&.id == @quote.user_id
  end

  def quote_params
    params.require(:quote).permit(
      :qtext, :qyear, :qcom, :ispublic, :philosopher_id,
      quote_categories_attributes: [:id, :category_id, :_destroy]
    )
  end
end