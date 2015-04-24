class Private::JobEstimatesController < ApplicationController

  layout "private"
  filter_access_to :all

  def index
    @page_title = "Job Estimates"
    @job_estimates = JobEstimate.includes(:client).order('id desc')
  end

  def show
    @job_estimate = JobEstimate.find(params[:id], include: [:client])
    @page_title = "Show Job Estimate"
  end

  def new
    @job_estimate = JobEstimate.new
    @page_title = "New Job Estimate"
    @clients = Client.scoped.order(:name)
    @materials = Material.active.includes(:manufacturer)
  end

  def create
    @job_estimate = JobEstimate.new(params[:job_estimate])

    @page_title = "New Job Estimate"

    if @job_estimate.save
      flash[:notice] = "Job Estimate created!"
      redirect_to private_job_estimates_path
    else
      @clients = Client.scoped.order(:name)
      @materials = Material.active.includes(:manufacturer)
      render action: :new
    end
  end

  def edit
    @job_estimate = JobEstimate.find(params[:id])
    @page_title = "Edit Job Estimate"
    @clients = Client.scoped.order(:name)
    @materials = Material.active.includes(:manufacturer)
  end

  def update
    @job_estimate = JobEstimate.find(params[:id])
    @page_title = "Edit Job Estimate"

    if @job_estimate.update_attributes(params[:job_estimate])
      flash[:notice] = "Job Estimate updated!"
      redirect_to private_job_estimate_path(@job_estimate)
    else
      @clients = Client.scoped.order(:name)
      @materials = Material.active.includes(:manufacturer)
      render action: :edit
    end
  end

  def destroy
    @job_estimate = JobEstimate.find(params[:id])
    @job_estimate.destroy
    redirect_to private_job_estimates_path
  end
end
