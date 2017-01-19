class HistogramsToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    remove_reference :histograms, :image
    change_table :histograms do |t|
      t.references :histogramable, polymorphic: true, index: true
    end
  end
end
