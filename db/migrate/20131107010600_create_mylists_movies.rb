class CreateMylistsMovies < ActiveRecord::Migration
  def change
    create_join_table :mylists, :movies do |t|
      t.integer :mylist_id, :null => false
      t.integer :movie_id, :null => false

      t.index :mylist_id
      t.index :movie_id
    end
  end
end
