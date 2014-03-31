class CreateMylistLogs < ActiveRecord::Migration
  def change
    create_table :mylist_logs do |t|
      t.integer :mylist_id
      t.integer :amount_of_view
      t.integer :amount_of_mylist
      t.integer :amount_of_comment

      t.timestamps
    end
  end
end
