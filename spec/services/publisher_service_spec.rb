# frozen_string_literal: true

require 'rails_helper'
require 'bunny-mock'
RSpec.describe PublisherService, type: :service do
  let(:queue_name) { 'test_queue' }
  let(:payload) { { message: 'Test message' }.to_json }
  let(:routing_key) { 'test_routing_key' }
  let(:exchange_name) { 'test_exchange' }
  let(:channel) { double('Channel') }
  let(:exchange) { double('Exchange') }
  let(:queue_options) { PublisherService::DEFAULT_OPTIONS }
  before do
    # Configuração da conexão BunnyMock para simular o RabbitMQ
    connection = BunnyMock.new
    allow(ConnectionManager).to receive(:instance).and_return(connection)
    allow(ConnectionManager.instance).to receive(:channel).and_return(channel)
    allow(channel).to receive(:queue).with(queue_name, queue_options).and_return(double('Queue').as_null_object)
  end
  describe '.publish' do
    it 'publishes a message to default exchange' do
      allow(channel).to receive(:topic).with('default', PublisherService::DEFAULT_OPTIONS).and_return(exchange)
      expect(exchange).to receive(:publish).with(payload, routing_key: queue_name)
      PublisherService.publish(queue_name, payload)
    end

    it 'publishes a message with routing key' do
      allow(channel).to receive(:topic).with('default', PublisherService::DEFAULT_OPTIONS).and_return(exchange)
      expect(exchange).to receive(:publish).with(payload, routing_key: routing_key)
      PublisherService.publish(queue_name, payload, routing_key)
    end

    it 'publishes a message with routing key and exchange' do
      allow(channel).to receive(:topic).with(exchange_name, PublisherService::DEFAULT_OPTIONS).and_return(exchange)
      expect(exchange).to receive(:publish).with(payload, routing_key: routing_key)
      PublisherService.publish(queue_name, payload, routing_key, exchange_name)
    end
  end
end
