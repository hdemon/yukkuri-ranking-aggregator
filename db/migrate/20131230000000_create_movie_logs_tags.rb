class CreateMovieLogsTags < ActiveRecord::Migration
  def change
    create_join_table :movie_logs, :tags do |t|
      t.index :tag_id
      t.index :movie_log_id
    end
  end
end
