class CreateMylistMovies < ActiveRecord::Migration
  def change
    create_table :mylist_movies do |t|
      t.integer :mylist_id, :null => false
      t.integer :movie_id, :null => false
    end
  end
end
