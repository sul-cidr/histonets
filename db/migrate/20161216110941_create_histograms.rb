class CreateHistograms < ActiveRecord::Migration[5.0]
  def change
    create_table :histograms do |t|
      t.references :image
      t.binary :histogram

      t.timestamps
    end
  end
end
