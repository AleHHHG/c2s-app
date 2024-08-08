# frozen_string_literal: true

require 'bunny'
class PublisherService
  DEFAULT_OPTIONS = { durable: true, auto_delete: false }.freeze

  def self.publish(queue_name, payload, routing_key = nil, exchange_name = 'default')
    routing_key = queue_name if routing_key.blank?
    channel = ConnectionManager.instance.channel
    exchange = channel.topic(exchange_name, DEFAULT_OPTIONS)
    channel.queue(queue_name, DEFAULT_OPTIONS).bind(exchange, routing_key: routing_key)
    exchange.publish(payload, routing_key: routing_key)
  end
end
