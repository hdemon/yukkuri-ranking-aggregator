class RenameColumnOfPartOneMovies < ActiveRecord::Migration
  def change
    rename_column :part_one_movies, :series_mylist, :series_mylist_id
  end
end
