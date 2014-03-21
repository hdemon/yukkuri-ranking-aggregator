class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :video_id
      t.integer :thread_id
      t.string :url
      t.string :title
      t.text :description
      t.string :thumbnail_url
      t.datetime :publish_date
      t.integer :length
      t.timestamps
    end

    add_index :movies, [:thread_id], unique: true
  end
end
