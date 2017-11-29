class CreateCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :competitions do |t|
      t.references :group, index: true, foreign_key: true
      t.date :start_date, :null => Date.today, :default => Date.today
      t.date :end_date, :null => Date.today, :default => Date.today
      t.timestamps
      t.string :metric_name
      t.string :metric_unit
    end
  end
end
