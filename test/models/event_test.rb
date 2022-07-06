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
require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
