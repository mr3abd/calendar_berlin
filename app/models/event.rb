# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  description    :text
#  end_date       :date
#  image_url      :string
#  start_date     :date
#  title          :string
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint
#  data_source_id :bigint
#  location_id    :bigint
#
# Indexes
#
#  index_events_on_category_id     (category_id)
#  index_events_on_data_source_id  (data_source_id)
#  index_events_on_location_id     (location_id)
#
class Event < ApplicationRecord
  # Includes
  include Filterable

  #Scopes
  scope :filter_by_title, ->(title) { where('title like ?', "%#{sanitize_sql_like(title)}%") }
  scope :filter_by_category, ->(category) { where(category: Category.where('title like ?', "%#{sanitize_sql_like(category)}%")) }
  scope :filter_by_location, ->(location) { where(location: Location.where('title like ?', "%#{sanitize_sql_like(location)}%")) }
  scope :filter_by_data_source, ->(data_source) { where(data_source: DataSource.where('title like ?', "%#{sanitize_sql_like(data_source)}%")) }
  scope :filter_by_start_date, ->(start_date) { where(start_date: start_date..) }
  scope :filter_by_end_date, ->(end_date) { where(end_date: ..end_date) }

  # Relationship
  belongs_to :data_source
  belongs_to :category
  belongs_to :location

  # Make url as slug to not repat any data
  validates :url, presence: true, uniqueness: true

  def full_dates
    "#{start_date&.strftime('%F')} - #{end_date&.strftime('%F')}"
  end
  def self.actives_dependency
    # underscore for attributes
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
