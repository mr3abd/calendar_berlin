# == Schema Information
#
# Table name: data_sources
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DataSource < ApplicationRecord
  has_many :events
end
