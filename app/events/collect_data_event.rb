# frozen_string_literal: true

class CollectDataEvent < BaseEvent
  QUEUE_NAME = 'scraping.run'

  def initialize(payload)
    @queue_name = QUEUE_NAME
    @payload = payload
  end
end
