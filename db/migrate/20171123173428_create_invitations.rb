class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.timestamps
      t.string :email
      t.references :group, index: true, foreign_key: true
    end
  end
end
