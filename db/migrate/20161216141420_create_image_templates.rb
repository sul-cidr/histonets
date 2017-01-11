class CreateImageTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :image_templates do |t|
      t.references :collection_template, foreign_key: true
      t.string :image_url
      t.integer :threshold
      t.binary :mask

      t.timestamps
    end
  end
end
