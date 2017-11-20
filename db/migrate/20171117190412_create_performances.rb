class CreatePerformances < ActiveRecord::Migration[5.1]
  def change
    create_table :performances do |t|
      t.date :date
      t.integer :count
      t.boolean :entered, :null => false, :default => false
      t.timestamps
      t.references :metric, index: true, foreign_key: true
    end
  end
end
