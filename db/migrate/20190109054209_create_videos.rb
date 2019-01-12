class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :image_url_large
      t.string :image_url_small
      t.timestamps
    end
  end
end
