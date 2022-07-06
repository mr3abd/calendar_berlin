class EventController < ApplicationController
  def index
    @pagy, @events = pagy(Event.filter(filtering_params))
  end


  private

  def filtering_params
    params.slice(:title, :less_time, :ratings, :category)
  end
end
