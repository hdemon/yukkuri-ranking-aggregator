class AddPartOneMovies < ActiveRecord::Migration
  def change
    create_table :part_one_movies do |t|
      t.string :video_id
      t.text :mylist_references
      t.datetime :publish_date
      t.integer :series_mylist

      t.timestamps
    end

    # add_index :part_one_movies, [:video_id], unique: true
  end
end
