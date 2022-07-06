class EventController < ApplicationController
  def index
    @pagy, @events = pagy(Event.filter(filtering_params))
  end

  def seed_data
    Event.seed_json_data
  end


  private

  def filtering_params
    params.slice(:title, :location, :start_date, :end_date, :category)
  end
end
