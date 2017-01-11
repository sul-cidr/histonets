class AddStatusToImageTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :image_templates, :status, :boolean
  end
end
