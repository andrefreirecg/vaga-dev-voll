class Conversation < ApplicationRecord
    belongs_to :user_a, class_name: 'User'
    belongs_to :user_b, class_name: 'User'

    validates :user_a_id, presence: true
    validates :user_b_id, presence: true

    validates :user_a_id, uniqueness: { scope: :user_b_id, message: 'conversation between these users already exists' }

    validate :unique_users_combination

    private

    def unique_users_combination
      if Conversation.where(user_a_id: user_b_id, user_b_id: user_a_id).exists?
        errors.add(:base, 'conversation between these users already exists')
      end
    end
  end
