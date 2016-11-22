class AddImageToCollectionTemplate < ActiveRecord::Migration[5.0]
  def change
    add_reference :collection_templates, :image, foreign_key: true
  end
end
