class CreateCollectionsAndImages < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.integer :year

      t.timestamps
    end

    create_table :images do |t|
      t.string :file_name

      t.timestamps
    end
    add_index :images, :file_name, unique: true

    create_table :collections_images, id: false do |t|
      t.belongs_to :collection, index: true
      t.belongs_to :image, index: true
    end
  end
end
