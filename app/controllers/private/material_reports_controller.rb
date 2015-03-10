class Private::MaterialReportsController < ApplicationController

  layout "private", :except => "print"
  filter_access_to :all

  def index
    @page_title = "Material Reports"

    @material_reports = MaterialReport
    if params[:query].present?
      @material_reports = @material_reports.where('jobs.name ilike :query', :query => "%#{params[:query]}%")
    end
    @material_reports = @material_reports.paginate :page => params[:page], :order => 'material_reports.id DESC', :per_page => 50, :include => [:job, :gun_sheet, :load_sheet]
  end

  def show
    @material_report = MaterialReport.find(params[:id], :include => [:load_sheet, :gun_sheet, :job])
    @page_title = @material_report.label
    @job_marking_cats = Array.new
  end

  def print
    @material_report = MaterialReport.find(params[:id], :include => [:load_sheets, :gun_sheets])
    @page_title = @material_report.label
    @job_marking_cats = Array.new
    @gun_sheets = @material_report.gun_sheets
    @load_sheets = @material_report.load_sheets
  end

  def new
    @job = Job.find(params[:job_id], :include => [:load_sheets, :gun_sheets])
    @load_sheets = @job.load_sheets(:order => 'id ASC')
    @gun_sheets = @job.gun_sheets(:order => 'id ASC')
    @material_report = MaterialReport.new
    @material_report.created_by = current_user.id
    @page_title = "New Material Report for #{@job.label}"
  end

  def create
    @job = Job.find(params[:job_id])
    @material_report = @job.material_reports.build(params[:material_report])
    @material_report.created_by = current_user.id

    @load_sheet = LoadSheet.find_by_id(params[:material_report][:load_sheet_id])
    unless @load_sheet.nil?
      @material_report.yellow_dip_start = @load_sheet.adjusted_yellow_dip_start
      @material_report.yellow_dip_end = @load_sheet.adjusted_yellow_dip_end
      @material_report.white_dip_start = @load_sheet.adjusted_white_dip_start
      @material_report.white_dip_end = @load_sheet.adjusted_white_dip_end
    end

    if @material_report.save
      flash[:notice] = "Material Report created!"
      redirect_to private_material_report_url(@material_report)
    else
      render :action => :new
    end
  end

  def edit
    @material_report = MaterialReport.find(params[:id], :include => [:job])
    @load_sheets = LoadSheet.where(:job_id => @material_report.job_id).order('created_at DESC')
    @gun_sheets = GunSheet.where(:job_id => @material_report.job_id).order('created_at DESC')
    @page_title = "Edit Material Report #{@material_report.id}"
  end

  def update
    @material_report = MaterialReport.find(params[:id])
    if @material_report.update_attributes(params[:material_report])
      flash[:notice] = "Material Report updated!"
      redirect_to private_material_report_url(@material_report)
    else
      render :action => :edit
    end
  end

  def update_dips
    @material_report = MaterialReport.find(params[:id])

    if @material_report.update_attributes(params[:material_report])
      flash[:notice] = "Material Reports Dips saved!"
      redirect_to private_material_report_url(@material_report)
    else
      render :action => :show
    end
  end

  def destroy
    @material_report = MaterialReport.find(params[:id])
    @material_report.destroy
    flash[:notice] = 'Material Report deleted!'
    redirect_to(private_material_reports_url)
  end

end
