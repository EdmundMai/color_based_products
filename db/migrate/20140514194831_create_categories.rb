class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :parent_id
      t.string :name
      t.text :description
      t.integer :level
      t.integer :sort_order

      t.timestamps
    end
  end
end
