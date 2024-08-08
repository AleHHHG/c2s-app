# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationService, type: :service do
  describe '.callback' do
    let!(:task) { create(:task) }
    let(:msg) { { task_id: task.id, updated_at: Time.current.to_s } }

    it 'updates the notification_date' do
      NotificationService.callback(msg)
      task.reload
      expect(task.notification_date).to eq(msg[:updated_at])
    end
  end
end
