class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  after_create :increment_message_count

  private

  def increment_message_count
    conversation.increment!(:messages_count)
  end
end
