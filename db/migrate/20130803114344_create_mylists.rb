class CreateMylists < ActiveRecord::Migration
  def change
    create_table :mylists do |t|
      t.integer :mylist_id
      t.string :creator
      t.string :title
      t.string :url

      t.timestamps
    end

    add_index :mylists, [:mylist_id], unique: true
  end
end
