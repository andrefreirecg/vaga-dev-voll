class AddCascadeDeleteToConversations < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :conversations, column: :user_a_id
    remove_foreign_key :conversations, column: :user_b_id

    add_foreign_key :conversations, :users, column: :user_a_id, on_delete: :cascade
    add_foreign_key :conversations, :users, column: :user_b_id, on_delete: :cascade
  end
end
