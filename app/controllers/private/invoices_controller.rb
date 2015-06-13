class Private::InvoicesController < ApplicationController

  layout "private"
  filter_access_to :all

  def index
    @page_title = "Invoices"
    @invoices = Invoice.order('id desc')
  end

  def show
    @invoice = Invoice.find(params[:id])
    @page_title = "Invoice  ##{@invoice.invoice_number}"

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        render pdf: 'invoices', layout: 'pdf.html.erb'
      end
    end
  end

  def new
    @invoice = Invoice.new
    @page_title = "New Invoice"
    @clients = Client.order(:name)
    @gun_marking_categories = GunMarkingCategory.all
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @page_title = "New Job Estimate"

    if @invoice.save
      if params[:save_and_send]
        @invoice.emails.split(',').each do |email|
          SiteMailer.delay.send_invoice_notice(@invoice, email)
        end
      end
      flash[:notice] = "Job Estimate created!"
      redirect_to private_invoices_path
    else
      @clients = Client.order(:name)
      @gun_marking_categories = GunMarkingCategory.all
      render action: :new
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @page_title = "Edit invoice"
    @clients = Client.order(:name)
    @gun_marking_categories = GunMarkingCategory.all
  end

  def update
    @invoice = Invoice.find(params[:id])
    @page_title = "Edit Invoice"

    if @invoice.update_attributes(params[:invoice])
      if params[:save_and_send]
        @invoice.emails.split(',').each do |email|
          SiteMailer.delay.send_invoice_notice(@invoice, email)
        end
      end
      flash[:notice] = "Invoice updated!"
      redirect_to private_invoice_path(@invoice)
    else
      @clients = Client.order(:name)
      @gun_marking_categories = GunMarkingCategory.all
      render action: :edit
    end
  end

  # def destroy
  #   @job_estimate = JobEstimate.find(params[:id])
  #   @job_estimate.destroy
  #   redirect_to private_job_estimates_path
  # end

  # def collect_emails
  #   client = Client.find_by_name(params[:client_name])
  #   emails = ''
  #   if client
  #     i = 0
  #     client.client_contacts.each do |contact|
  #       i += 1
  #       emails << ', ' unless i == 1
  #       emails << "#{contact.email}"
  #     end
  #   end

  #   puts emails

  #   respond_to do |format|
  #     format.json  do
  #       render json: { emails: emails }
  #     end
  #   end
  # end

  # def delete_document
  #   @job_estimate = JobEstimate.find(params[:id])
  #   document = @job_estimate.assets.find(params[:asset_id])
  #   document.destroy

  #   flash[:notice] = 'Document deleted!'
  #   redirect_to private_job_estimate_path(@job_estimate)
  # end

  # def mark_invoice
  #   @job_estimate = JobEstimate.find(params[:id])
  #   @job_estimate.send("mark_as_#{params[:status].downcase}") if JobEstimate::STATE.values.include?(params[:status])

  #   respond_to do |format|
  #     format.html do
  #       redirect_to :back
  #     end
  #     format.js
  #   end
  # end
end
