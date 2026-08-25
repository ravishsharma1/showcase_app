class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def create
    @task = @project.tasks.build(task_params)
    @task.user = current_user
    authorize @task

    if @task.save
      redirect_to @project, notice: "Task was successfully created."
    else
      redirect_to @project, alert: @task.errors.full_messages.to_sentence
    end
  end

  def edit
    authorize @task
  end

  def update
    authorize @task
    if @task.update(task_params)
      redirect_to @project, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    redirect_to @project, notice: "Task was successfully destroyed."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date)
  end
end
