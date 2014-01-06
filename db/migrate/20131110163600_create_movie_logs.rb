class CreateMovieLogs < ActiveRecord::Migration
  def change
    create_table :movie_logs do |t|
      t.integer :movie_id, :null => false
      t.integer :view_counter, :null => false
      t.integer :mylist_counter, :null => false
      t.integer :comment_num, :null => false
    end
  end
end
