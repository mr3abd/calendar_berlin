class Event < ApplicationRecord
  belongs_to :data_source
  belongs_to :category
  belongs_to :location
  validates :url, presence: true
  def self.seed_json_data
    json_file= File.join(Rails.root, 'db', 'seeds_json', 'export_data.json')
    Scrap.start unless File.readable?(json_file)
    data = JSON.parse(File.read(json_file))
    data['data'].each do |event_data|
      event = new(title: event_data['title'], image_url: event_data['image_url'],
                  url: event_data['url'], description: event_data['description'],
                  start_date: event_data['start_date'], end_date: event_data['end_date'])
      # Location
      location = Location.find_or_create_by(title: event_data['location'])
      event.location = location

      # Category
      category = Category.find_or_create_by(title: event_data['category'])
      event.category = category

      # DataSource
      data_source = DataSource.find_or_create_by(title: event_data['data_source'])
      event.data_source = data_source

      event.save
      p "done add #{event.id}"
      p '#' * 5
    end
  end

end
