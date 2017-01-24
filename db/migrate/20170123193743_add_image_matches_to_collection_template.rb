class AddImageMatchesToCollectionTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :collection_templates, :image_matches, :text
  end
end
