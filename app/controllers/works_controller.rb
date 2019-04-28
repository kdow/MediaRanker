class WorksController < ApplicationController
  before_action :find_work, except: [:index, :new, :create]

  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    successful = @work.save
    if successful
      flash[:status] = :success
      flash[:message] = "Successfully saved a work with ID #{@work.id}"
      redirect_to works_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not create"
      render :new, status: :bad_request
    end
  end

  def show; end

  def edit; end

  def update
    if @work.update(work_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated work #{@work.id}"
      redirect_to work_path(@work)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save work #{@work.id}"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @work.destroy

    flash[:status] = :success
    flash[:message] = "Successfully deleted work #{@work.id}"
    redirect_to works_path
  end

  def upvote
    current_user = User.find_by(id: session[:user_id])
    if current_user
      @vote = Vote.new(work_id: @work.id, user_id: current_user.id)
      if @vote.save
        flash[:status] = :success
        flash[:message] = "Successfully upvoted!"
        redirect_to work_path(@work.id)
      else
        flash[:status] = :failure
        flash[:message] = "Could not upvote"
        render :show
      end
    else
      flash[:status] = :failure
      flash[:message] = "You must log in to do that"
      redirect_to login_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  def find_work
    @work = Work.find_by_id(params[:id])

    unless @work
      head :not_found
      return
    end
  end
end
