class Api::CrewsController < ApplicationController

  filter_access_to :all

  def jobs
    @crew = Crew.find(params[:id])
    @jobs = @crew.jobs.where(started_at: !nil)

    respond_to do |format|
      format.json {
        render json: {
            id: @crew.id,
            start_at: params[:start],
            end_at: params[:end]
        }
      }
    end
  end

end
