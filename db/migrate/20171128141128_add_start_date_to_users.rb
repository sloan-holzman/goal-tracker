class AddStartDateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :metrics, :start_date, :date, :null => Date.today, :default => Date.today
  end
end
