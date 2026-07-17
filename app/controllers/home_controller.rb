class HomeController < ApplicationController
  before_action :require_login, only: [:uindex, :uquotes, :aindex]

  def index
    @recent_quotes = Quote.public_quotes
                          .includes(:user, :philosopher, :categories)
                          .order(created_at: :desc)
                          .limit(10)
  end

  def uindex
    redirect_to admin_path and return if is_administrator?
    @my_quote_count = current_user.quotes.count
  end

  def aindex
    unless is_administrator?
      flash[:error] = "You are not authorised to access this resource."
      redirect_to(userhome_path) and return
    end
    @user_count         = User.count
    @quote_count        = Quote.count
    @philosopher_count  = Philosopher.count
    @category_count     = Category.count
    @suspended_count    = User.where(status: "Suspended").count
    @banned_count       = User.where(status: "Banned").count
  end

  def uquotes
    redirect_to admin_path and return if is_administrator?
    @quotes = current_user.quotes.includes(:philosopher, :categories).recent
  end

  def about
  end

  def search
    @categories = Category.order(:catname)
    @selected_category_id = params[:category_id].presence
    @keyword = params[:keyword].to_s.strip

    scope = Quote.includes(:user, :philosopher, :categories)

    scope = if is_administrator?
              scope
            elsif logged_in?
              scope.where("ispublic = ? OR user_id = ?", true, current_user.id)
            else
              scope.where(ispublic: true)
            end

    if @selected_category_id.present?
      scope = scope.joins(:categories).where(categories: { id: @selected_category_id })
    end

    if @keyword.present?
      scope = scope.where("qtext LIKE ?", "%#{@keyword}%")
    end

    @quotes = scope.order(created_at: :desc).distinct
  end
end