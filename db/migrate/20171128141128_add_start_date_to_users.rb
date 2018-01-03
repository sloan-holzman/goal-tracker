class AddStartDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :metrics, :start_date, :date, :null => Time.current.to_date, :default => Time.current.to_date
  end
end
