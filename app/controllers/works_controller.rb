class WorksController < ApplicationController
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

  def show
    work_id = params[:id]

    @work = Work.find_by(id: work_id)

    unless @work
      head :not_found
    end
  end

  def edit
    work_id = params[:id]

    @work = Work.find_by(id: work_id)

    unless @work
      head :not_found
    end
  end

  def update
    @work = Work.find_by(id: params[:id])

    unless @work
      head :not_found
      return
    end

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
    work_id = params[:id]

    work = Work.find_by(id: work_id)

    unless work
      head :not_found
      return
    end

    work.destroy

    flash[:status] = :success
    flash[:message] = "Successfully deleted work #{work.id}"
    redirect_to works_path
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
