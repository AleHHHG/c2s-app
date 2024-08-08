# frozen_string_literal: true

class ConnectionManager
  include Singleton

  attr_accessor :active_connection, :active_channel

  def establish_connection
    @active_connection = Bunny.new("#{RABBITMQ[:amqp]}")
    active_connection.start
    @active_channel = active_connection.create_channel

    @active_connection
  end

  def connection
    return active_connection if connected?

    establish_connection

    active_connection
  end

  def channel
    return active_channel if connected? && active_channel&.open?

    establish_connection

    active_channel
  end

  def connected?
    active_connection&.connected?
  end
end
