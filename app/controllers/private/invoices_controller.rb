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
    return unless params[:job_estimate]
    estimate = JobEstimate.where(id: params[:job_estimate]).first
    @invoice.customer_name = estimate.name_client
    @invoice.emails = estimate.emails
    @invoice.discount = estimate.discount
    @invoice.shipping_charges = estimate.shipping_charges
    @invoice.terms_and_cond = estimate.terms_and_conditions
    @invoice.customer_notes = estimate.client_notes
    @invoice.sub_total_amount = estimate.sub_total_amount
    @invoice.amount = estimate.total_amount
    estimate.estimate_items.each do |i|
      @invoice.invoice_items.new(
        title: i.title,
        description: i.description,
        quantity: i.quantity,
        price: i.price,
        total_price: i.total_price
      )
    end
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

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to private_invoices_path, notice: 'Invoice succsesfully removed'
  end
end
