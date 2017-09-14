class AddBlobsToCollectionTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :collection_templates, :blobs, :text
  end
end
