class CreateCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :competitions do |t|
      t.references :group, index: true, foreign_key: true
      t.date :start_date, :null => Time.current.to_date, :default => Time.current.to_date
      t.date :end_date, :null => Time.current.to_date, :default => Time.current.to_date
      t.timestamps
      t.string :metric_name
      t.string :metric_unit
    end
  end
end
