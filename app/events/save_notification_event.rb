# frozen_string_literal: true

class SaveNotificationEvent < BaseEvent
  QUEUE_NAME = 'notification.save'

  def initialize(payload)
    @queue_name = QUEUE_NAME
    @payload = payload
  end
end
