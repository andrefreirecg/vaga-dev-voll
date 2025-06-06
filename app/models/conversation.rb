class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  belongs_to :user_a, class_name: 'User'
  belongs_to :user_b, class_name: 'User'

  validates :user_a_id, presence: true
  validates :user_b_id, presence: true
  validates :user_a_id, uniqueness: { scope: :user_b_id, message: 'conversa entre esses usuários já existe' }

  validate :unique_users_combination
  validate :differents_user_conversation

  private

  def unique_users_combination
    if Conversation.where(user_a_id: user_b_id, user_b_id: user_a_id).exists?
      errors.add(:base, 'Conversa entre esses usuários já existe (inversa)')
    end
  end

  def differents_user_conversation
    if user_a_id == user_b_id
      errors.add(:base, 'Você não pode conversar consigo mesmo')
    end
  end
end
