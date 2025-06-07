class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :user_a, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :user_b, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.integer :messages_count, default: 0
      t.timestamps
    end

    add_index :conversations, [:user_a_id, :user_b_id], unique: true
  end
end
