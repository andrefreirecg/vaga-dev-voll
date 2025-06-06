class Message < ApplicationRecord
  belongs_to :conversation, counter_cache: true
  belongs_to :user

  after_create :increment_message_count

  private

  def increment_message_count
    conversation.increment!(:messages_count)
  end
end
