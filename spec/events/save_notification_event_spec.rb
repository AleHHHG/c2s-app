# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SaveNotificationEvent, type: :event do
  describe '#publish!' do
    subject { described_class.new(payload) }
    let(:task) { create(:task) }
    let(:payload) do
      {
        id: task.id, url: task.url, user_id: task.user_id, status: task.status 
      }
    end

    before do
      allow(PublisherService).to receive(:publish)
    end

    it 'return queue name' do
      subject.publish!
      expect(subject.queue_name).to include('notification.save')
    end
  end
end
