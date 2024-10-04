class CreateTagCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :tag_categories do |t|
      t.string :name
      t.string :code_name
      t.timestamps
    end

    add_index :tag_categories, :code_name, unique: true
  end
end
