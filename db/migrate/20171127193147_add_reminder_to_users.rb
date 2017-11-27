class AddReminderToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reminder, :boolean, :null => true, :default => true
    add_column :users, :reminder_frequency, :string, :null => "Weekly", :default => "Weekly"
    add_column :users, :reminder_day, :string, :null => "Thursday", :default => "Thursday"
  end
end
