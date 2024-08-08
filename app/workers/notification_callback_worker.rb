# frozen_string_literal: true

require 'sneakers'

class NotificationCallbackWorker
  include Sneakers::Worker

  from_queue 'notification.callback', prefetch: 5, threads: 5

  def work(msg)
    msg = JSON.parse(msg).deep_symbolize_keys
    NotificationService.callback(msg)
    ack!
  end
end
