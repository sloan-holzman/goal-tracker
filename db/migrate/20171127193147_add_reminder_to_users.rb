class AddReminderToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reminder, :boolean, :null => true, :default => true
  end
end
