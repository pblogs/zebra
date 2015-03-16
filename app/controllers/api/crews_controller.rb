class Api::CrewsController < ApplicationController

  filter_access_to :all

  def jobs
    @crew = Crew.find(params[:id])
    @jobs = @crew.jobs.where('started_on IS NOT NULL')

    respond_to do |format|
      format.json { render json: @jobs, root: false }
    end
  end

  def schedule_job
    @job = Job.find(params[:id])
    @job.update_attributes(params[:job])

    respond_to do |format|
      format.json { render json: @job, root: false }
    end
  end
end
