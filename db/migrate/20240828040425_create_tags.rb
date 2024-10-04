class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :code_name
      t.references :tag_category
      t.timestamps
    end

    add_index :tags, :code_name, unique: true
  end
end
