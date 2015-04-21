class CreateCms < ActiveRecord::Migration
  
  def self.up
    create_table :comfy_cms_sections do |t|
      t.integer :page_id,         :null => false
      t.integer :layout_id
      t.string  :tag_identifier
      t.integer :position,        :null => false, :default => 0
      t.boolean :is_published,    :null => false, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :comfy_cms_sections
  end
end