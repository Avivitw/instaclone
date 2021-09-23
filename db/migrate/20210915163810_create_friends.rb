class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.integer :requester_id
      t.integer :requested_id
      t.string :status

      t.timestamps
    end
  end
end
