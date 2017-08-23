class AddGraphOptionsToCollectionTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :collection_templates, :graph, :text
  end
end
