class RemoveColumnImageFromHistogram < ActiveRecord::Migration[5.0]
  def change
    if column_exists? :histograms, :image_id
      remove_reference :histograms, :image
    end
  end
end
