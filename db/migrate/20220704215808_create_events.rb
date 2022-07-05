class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.string :url
      t.date :start_date
      t.date :end_date
      t.references :location
      t.references :category
      t.references :data_source

      t.timestamps
    end
  end
end
