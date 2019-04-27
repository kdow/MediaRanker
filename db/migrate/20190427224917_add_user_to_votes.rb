class AddUserToVotes < ActiveRecord::Migration[5.2]
  def change
    add_reference :votes, :user, index: true
    add_foreign_key :votes, :users
  end
end
