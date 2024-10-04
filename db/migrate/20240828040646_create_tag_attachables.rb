class CreateTagAttachables < ActiveRecord::Migration[7.1]
  def change
    create_table :tag_attachables do |t|
      t.references :tag
      t.references :taggable, polymorphic: true
      t.timestamps
    end
  end
end
