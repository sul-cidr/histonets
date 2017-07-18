class AddRidgesParametersToCollectionTemplateModel < ActiveRecord::Migration[5.1]
  def change
    add_column :collection_templates, :ridges, :text
  end
end
