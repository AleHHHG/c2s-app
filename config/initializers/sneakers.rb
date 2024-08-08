# frozen_string_literal: true
Sneakers.configure(
  amqp: RABBITMQ[:amqp],
  vhost: RABBITMQ[:vhost],
  workers: 5
)
Sneakers.logger.level = Logger::INFO
