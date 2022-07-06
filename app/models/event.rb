class Event < ApplicationRecord
  belongs_to :data_source
  belongs_to :category
  belongs_to :location

  # Make url as slug to not repat any data
  validates :url, presence: true, uniqueness: true

  def self.actives_dependency
    # underscore for atttribbute
    [Location, Category, DataSource]
  end
  def self.seed_json_data
    json_file = File.join(Rails.root, 'db', 'seeds_json', 'export_data.json')
    Scrap.start unless File.readable?(json_file)
    data = JSON.parse(File.read(json_file))
    data['data'].each do |event_data|
      event = new(title: event_data['title'], image_url: event_data['image_url'],
                  url: event_data['url'], description: event_data['description'],
                  start_date: event_data['start_date'], end_date: event_data['end_date'])
      actives_dependency.each do |dependency|
        # to add for or Associate like Location Category DataSource
        value = dependency.find_or_create_by(title: event_data["#{dependency.to_s.underscore}"])
        event.send("#{dependency.to_s.underscore}=", value)
      end
      event.save
    end
  end
end
