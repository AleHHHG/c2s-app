# frozen_string_literal: true

class Task < ApplicationRecord
  validates :url, :user_id, presence: true
  enum status: [:pending, :in_progress, :done, :error]

  scope :by_user, ->(user_id) { where(user_id: user_id)}

  def event_attributes
    { id: id, url: url, user_id: user_id, status: status }
  end
end
