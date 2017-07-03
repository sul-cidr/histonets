class CreateProcessTrackers < ActiveRecord::Migration[5.1]
  def change
    create_table :process_trackers do |t|
      t.references :trackable, polymorphic: true, index: true
      t.string :job_id
      t.string :status
      t.string :job_type
      t.text :arguments
      t.integer :executions

      t.timestamps
    end
  end
end
