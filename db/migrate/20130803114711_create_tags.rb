class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :text, limit: 40
    end

    add_index :tags, [:text], unique: true
  end
end
