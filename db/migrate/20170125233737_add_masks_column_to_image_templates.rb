class AddMasksColumnToImageTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :image_templates, :masks, :text
  end
end
