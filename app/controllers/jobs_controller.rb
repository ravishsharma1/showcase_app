class JobsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_job, only: %i[show edit update destroy]
  before_action :set_company, only: %i[new create]

  def index
    @q = Job.published.ransack(params[:q])
    @jobs = @q.result.includes(:company).recent
    @jobs = @jobs.where(employment_type: params[:employment_type]) if params[:employment_type].present?
    @jobs = @jobs.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?
    @jobs = @jobs.limit(20)
  end

  def show
    @application = current_user&.job_applications&.find_by(job: @job)
  end

  def new
    @job = @company.jobs.build
    authorize @job
  end

  def create
    @job = @company.jobs.build(job_params)
    authorize @job

    if @job.save
      redirect_to @job, notice: "Job was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @job
  end

  def update
    authorize @job
    if @job.update(job_params)
      redirect_to @job, notice: "Job was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @job
    @job.destroy
    redirect_to jobs_url, notice: "Job was successfully destroyed."
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def set_company
    @company = current_user.companies.find(params[:company_id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :location, :salary_min, :salary_max, :employment_type, :status)
  end
end
