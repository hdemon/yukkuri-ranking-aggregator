class RenameTableOfMoviesMylists < ActiveRecord::Migration
  def change
    rename_table :movies_mylists, :mylists_movies
  end
end
