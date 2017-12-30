class AddStreaksToMetrics < ActiveRecord::Migration[5.1]
  def change
    add_column :metrics, :last_day_undone, :date, :null => Date.today, :default => Date.today
    add_column :metrics, :last_week_undone, :date, :null => Date.today, :default => Date.today
  end
end
