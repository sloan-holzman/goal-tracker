class AddLastToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_date_created, :date
    add_column :users, :last_date_entered, :date
  end
end
