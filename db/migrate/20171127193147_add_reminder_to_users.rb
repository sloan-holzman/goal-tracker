class AddReminderToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reminder, :boolean, :null => true, :default => true
    add_column :users, :reminder_frequency, :string, :null => "weekly", :default => "weekly"
    add_column :users, :reminder_day, :string, :null => "thursday", :default => "thursday"
  end
end
