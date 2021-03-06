class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.timestamps
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.boolean :admin, :null => false, :default => false
    end
  end
end
