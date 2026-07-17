class PhilosophersController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:edit, :update, :destroy]
  before_action :set_philosopher, only: [:show, :edit, :update, :destroy]

  def index
    @philosophers = Philosopher.where("LOWER(fname) <> ?", "anonymous")
                               .order(:lname, :fname)
  end

  def show
  end

  def new
    @philosopher = Philosopher.new
  end

  def create
    @philosopher = Philosopher.new(philosopher_params)
    if @philosopher.save
      flash[:notice] = "Philosopher '#{@philosopher.display_name}' added successfully."
      if is_administrator?
        redirect_to philosophers_path
      else
        redirect_to new_quote_path
      end
    else
      flash.now[:error] = "Could not add philosopher. Please correct the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @philosopher.update(philosopher_params)
      flash[:notice] = "Philosopher updated successfully."
      redirect_to philosophers_path
    else
      flash.now[:error] = "Update failed. Please correct the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @philosopher.destroy
    flash[:notice] = "Philosopher deleted. Associated quotes have been disassociated."
    redirect_to philosophers_path
  end

  private

  def set_philosopher
    @philosopher = Philosopher.find_by(id: params[:id])
    unless @philosopher
      flash[:error] = "Philosopher not found."
      redirect_to philosophers_path
    end
  end

  def philosopher_params
    params.require(:philosopher).permit(:fname, :lname, :byear, :dyear, :bio)
  end
end