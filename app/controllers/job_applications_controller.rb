class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job

  def create
    @application = @job.job_applications.build(job_application_params)
    @application.user = current_user

    if @application.save
      redirect_to @job, notice: "Your application was submitted successfully."
    else
      redirect_to @job, alert: @application.errors.full_messages.to_sentence
    end
  end

  def destroy
    @application = current_user.job_applications.find(params[:id])
    @application.destroy
    redirect_to @job, notice: "Application withdrawn."
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def job_application_params
    params.require(:job_application).permit(:cover_letter)
  end
end
