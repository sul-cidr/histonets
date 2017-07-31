class AddPaletteToCollection < ActiveRecord::Migration[5.1]
  def change
    add_column :collections, :palette, :text
  end
end
