class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :conversation, null: false, foreign_key: true, type: :uuid
      t.text :content
      t.string :attachment_url
      t.timestamps
    end
  end
end
