class Api::EventsController < ApplicationController
  def jobs
    @crew = Crew.find(params[:id])
    @events = @crew.events #.where('started_on IS NOT NULL')
    render json: @events, each_serializer: EventsSerializer, root: false
  end

  def destroy
    event = Event.where(id: params[:id]).first
    event.destroy if event
    render json: ''
  end
end
