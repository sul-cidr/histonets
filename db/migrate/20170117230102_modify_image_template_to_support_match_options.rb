class ModifyImageTemplateToSupportMatchOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :image_templates, :match_options, :text
    remove_column :image_templates, :threshold, :integer
  end
end
