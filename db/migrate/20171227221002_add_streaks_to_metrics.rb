class AddStreaksToMetrics < ActiveRecord::Migration[5.1]
  def change
    add_column :metrics, :last_day_undone, :date, :null => Time.current.to_date, :default => Time.current.to_date
    add_column :metrics, :last_week_undone, :date, :null => Time.current.to_date, :default => Time.current.to_date
  end
end
