class AddWorksToVotes < ActiveRecord::Migration[5.2]
  def change
    add_reference :votes, :work, index: true
    add_foreign_key :votes, :works
  end
end
