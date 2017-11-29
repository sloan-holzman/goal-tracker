class ChangeColumnsMetrics < ActiveRecord::Migration[5.1]
  def change
    change_column :metrics, :target, :integer, :default => 5, :null => 5
    change_column :metrics, :duration, :string, :default => 'Week', :null => 'Week'
  end
end
