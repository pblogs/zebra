class Private::JobEstimatesController < ApplicationController

  layout "private"
  filter_access_to :all

  def index
    @page_title = "Job Estimates"
    @job_estimates = JobEstimate.order('id desc')
  end

  def show
    @job_estimate = JobEstimate.find(params[:id])
    @page_title = "Show Job Estimate"

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        render pdf: "job_estimates", layout: 'pdf.html.erb'   # Excluding ".pdf" extension.
      end
    end
  end

  def new
    @job_estimate = JobEstimate.new
    @page_title = "New Job Estimate"
    @clients = Client.order(:name)
    @gun_marking_categories = GunMarkingCategory.all
  end

  def create
    @job_estimate = JobEstimate.new(params[:job_estimate])
    @page_title = "New Job Estimate"

    if @job_estimate.save
      if params[:save_and_send]
        @job_estimate.emails.split(',').each do |email|
          SiteMailer.delay.send_job_estimate_notice(@job_estimate, email)
        end
      end
      flash[:notice] = "Job Estimate created!"
      redirect_to private_job_estimates_path
    else
      @clients = Client.order(:name)
      @gun_marking_categories = GunMarkingCategory.all
      render action: :new
    end
  end

  def edit
    @job_estimate = JobEstimate.find(params[:id])
    @page_title = "Edit Job Estimate"
    @clients = Client.order(:name)
    @gun_marking_categories = GunMarkingCategory.all
  end

  def update
    @job_estimate = JobEstimate.find(params[:id])
    @page_title = "Edit Job Estimate"

    if @job_estimate.update_attributes(params[:job_estimate])
      if params[:save_and_send]
        @job_estimate.emails.split(',').each do |email|
          SiteMailer.delay.send_job_estimate_notice(@job_estimate, email)
        end
      end
      flash[:notice] = "Job Estimate updated!"
      redirect_to private_job_estimate_path(@job_estimate)
    else
      @clients = Client.order(:name)
      @gun_marking_categories = GunMarkingCategory.all
      render action: :edit
    end
  end

  def destroy
    @job_estimate = JobEstimate.find(params[:id])
    @job_estimate.destroy
    redirect_to private_job_estimates_path
  end

  def collect_emails
    client = Client.find_by_name(params[:client_name])
    emails = ''
    if client
      i = 0
      client.client_contacts.each do |contact|
        i += 1
        emails << ', ' unless i == 1
        emails << "#{contact.email}"
      end
    end

    puts emails

    respond_to do |format|
      format.json  do
        render json: { emails: emails }
      end
    end
  end

  def delete_document
    @job_estimate = JobEstimate.find(params[:id])
    document = @job_estimate.assets.find(params[:asset_id])
    document.destroy

    flash[:notice] = 'Document deleted!'
    redirect_to private_job_estimate_path(@job_estimate)
  end

  def mark_invoice
    @job_estimate = JobEstimate.find(params[:id])
    @job_estimate.update_attributes(
      state: JobEstimate::STATE.invert[params[:status]]
    ) if JobEstimate::STATE.values.include?(params[:status])

    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js
    end
  end
end
