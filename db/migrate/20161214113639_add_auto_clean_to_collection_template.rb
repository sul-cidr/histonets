class AddAutoCleanToCollectionTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :collection_templates, :auto_clean, :boolean
  end
end
