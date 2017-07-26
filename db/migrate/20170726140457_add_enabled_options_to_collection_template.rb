class AddEnabledOptionsToCollectionTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :collection_templates, :enabled_options, :text
  end
end
