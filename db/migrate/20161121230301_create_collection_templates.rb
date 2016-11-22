class CreateCollectionTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :collection_templates do |t|
      t.references :collection, foreign_key: true
      t.text :crop_bounds
      t.text :image_clean
      t.text :image_paths
      t.text :image_graph

      t.timestamps
    end
  end
end
