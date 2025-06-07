class AddDeletedFlagsToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :user_a_deleted, :boolean
    add_column :conversations, :user_b_deleted, :boolean
  end
end
