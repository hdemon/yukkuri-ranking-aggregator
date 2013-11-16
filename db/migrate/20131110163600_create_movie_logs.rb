class CreateMovieLogs < ActiveRecord::Migration
  def change
    create_table :movie_logs do |t|
      t.integer :movie_id, :null => false
      t.integer :view_counter, :null => false
      t.integer :mylist_counter, :null => false
      t.integer :comment_num, :null => false

      t.string :tag_1
      t.string :tag_2
      t.string :tag_3
      t.string :tag_4
      t.string :tag_5
      t.string :tag_6
      t.string :tag_7
      t.string :tag_8
      t.string :tag_9
      t.string :tag_10
      t.string :tag_11
    end
  end
end
