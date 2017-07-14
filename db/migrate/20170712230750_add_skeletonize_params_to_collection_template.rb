class AddSkeletonizeParamsToCollectionTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :collection_templates, :skeletonize, :text
  end
end
