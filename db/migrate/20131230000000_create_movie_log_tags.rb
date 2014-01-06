class CreateMovieLogTags < ActiveRecord::Migration
  def change
    create_table :movie_log_tags do |t|
      t.integer :tag_id
      t.integer :movie_log_id
      # t.timestamps
    end
  end
end
