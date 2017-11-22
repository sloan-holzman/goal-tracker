class CreateMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :metrics do |t|
      t.string :name
      t.string :unit
      t.integer :target
      t.boolean :good, :null => false, :default => true
      t.string :duration
      t.timestamps
    end
  end
end
