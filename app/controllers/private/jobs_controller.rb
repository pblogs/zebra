class Private::JobsController < ApplicationController

  layout "private"
  filter_access_to :only => [:index, :new, :update, :edit, :destroy, :create, :load_job_supporting_data]

  def index(archived = false)
    @page_title ||= "Jobs on Hand"

    jobs = Job.includes(:client, :completion, :job_markings, :crews).order('jobs.id DESC')
    if params[:query].present?
      @page_title = "Search Results"
      sql  = 'jobs.name           ilike :query OR
              completions.name    ilike :query OR
              crews.name          ilike :query OR
              clients.name        ilike :query OR
              location_name       ilike :query OR
              location_name       ilike :query OR
              jobs.reference_code ilike :query OR
              jobs.pay_status     ilike :query OR
              jobs.zoho_details   ilike :query'
      @active_jobs   = jobs.active.where(sql, :query => "%#{params[:query]}%")
      @archived_jobs = jobs.archived.where(sql, :query => "%#{params[:query]}%")
    else
      @jobs = jobs.where(:is_archived => archived)
    end
  end


  def archived_jobs
    @page_title = "Archived Jobs on Hand"
    index(archived = true)
    render :index
  end

  def show
    @job = Job.find(params[:id], :include => [:job_locations, :completion, :client, :load_sheets, {:job_markings => :gun_marking_category}, :job_sheets, {:comments => :user} ])
    @page_title = @job.label
    @show_archived = params[:show_archived] == 'true'
  end

  def new
    @job = Job.new
    @crews = Crew.all
    1.times { @job.job_markings.build }
    @page_title = "New Job on Hand"
    load_job_supporting_data
  end

  def create
    @job = Job.new(params[:job])
    @page_title = "New Job on Hand"
    load_job_supporting_data
    if @job.save
      flash[:notice] = "Job on Hand created!"
      redirect_to(private_home_path)
    else
      render :action => :new
    end
  end

  def edit
    @job = Job.find(params[:id])
    @crews = Crew.all
    @page_title = "Edit #{@job.label}"
    load_job_supporting_data
  end

  def update
    @job = Job.find(params[:id])

    params[:job][:crew_ids] ||= []
    if @job.update_attributes(params[:job])
     if @job.is_archived == true
       @job.crews.each do |g|
         g = nil
       end
       @job.update_attributes({:crews => []})
     end
      redirect_to private_job_url(@job.id)
    else
      @crews = Crew.all
      load_job_supporting_data
      render :action => :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:notice] = 'Job on Hand deleted!'
    redirect_to(private_jobs_url)
  end

  def delete_document
    @job = Job.find(params[:id])
    document = @job.assets.find(params[:asset_id])
    document.destroy

    flash[:notice] = 'Job document deleted!'
    redirect_to  private_job_path(@job)
  end

private

  def load_job_supporting_data
    @crews = Crew.all
    @clients = Client.scoped.order(:name)
    @completions = Completion.scoped.order(:id)
    @users = User.where(:employment_state => "Employed").order(:first_name).all
    @gun_marking_categories = GunMarkingCategory.scoped.order(:name)
  end

end
