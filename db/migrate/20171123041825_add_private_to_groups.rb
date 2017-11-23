class AddPrivateToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :private, :boolean, :null => false, :default => false
  end
end
