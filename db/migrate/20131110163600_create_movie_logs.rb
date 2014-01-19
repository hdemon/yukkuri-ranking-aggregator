class CreateMovieLogs < ActiveRecord::Migration
  def change
    create_table :movie_logs do |t|
      t.integer :movie_id, :null => false
      t.integer :view_counter, :null => false
      t.integer :mylist_counter, :null => false
      t.integer :comment_num, :null => false
      t.datetime :created_at, :null => false
    end

    add_index :movie_logs, [:movie_id]
  end
end
