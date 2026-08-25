class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: %i[show edit update destroy]

  def index
    @companies = current_user.companies.recent
  end

  def show
    @jobs = @company.jobs.recent
  end

  def new
    @company = current_user.companies.build
    authorize @company
  end

  def create
    @company = current_user.companies.build(company_params)
    authorize @company

    if @company.save
      redirect_to @company, notice: "Company was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @company
  end

  def update
    authorize @company
    if @company.update(company_params)
      redirect_to @company, notice: "Company was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @company
    @company.destroy
    redirect_to companies_url, notice: "Company was successfully destroyed."
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :description, :website, :logo)
  end
end
