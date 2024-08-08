# frozen_string_literal: true

class BaseEvent
  attr_reader :queue_name, :payload

  def publish!
    PublisherService.publish(@queue_name, payload.to_json)
  end
end
