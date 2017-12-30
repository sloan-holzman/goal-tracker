class CreateWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :weeks do |t|
      t.date :date
      t.integer :total
      t.references :metric, index: true, foreign_key: true
    end
  end
end
