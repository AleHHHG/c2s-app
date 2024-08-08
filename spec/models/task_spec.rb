# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values([:pending, :in_progress, :done, :error]) }
  end

  describe 'scopes' do
    let(:task) { create(:task, user_id: 1) }
    let(:task_two) { create(:task, user_id: 2) }

    describe '.by_user' do
      it 'returns task that belong to usert' do
        expect(described_class.by_user(1)).to include(task)
        expect(described_class.by_user(1)).not_to include(task_two)
      end
    end
  end

end
