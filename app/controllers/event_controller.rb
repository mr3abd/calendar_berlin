class EventController < ApplicationController
  def index
    @pagy, @events = pagy(Event.filter(filtering_params))
  end


  private

  def filtering_params
    params.slice(:title, :location, :start_date, :end_date, :category)
  end
end
