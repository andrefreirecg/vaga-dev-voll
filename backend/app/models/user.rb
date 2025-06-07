class User < ApplicationRecord
    before_create :set_default_name

    validates :name, uniqueness: true

    has_many :messages, dependent: :destroy

    has_many :conversations_as_user_a, class_name: 'Conversation', foreign_key: 'user_a_id'
    has_many :conversations_as_user_b, class_name: 'Conversation', foreign_key: 'user_b_id'
    private

    def set_default_name
        return if name.present?
        loop do
            generated = "guesser_#{rand(1_000_000)}"
            unless User.exists?(name: generated)
                self.name = generated
                break
            end
        end
    end
end
