# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    url { "http://example.com" }
    user_id { 1 }
    status { :pending }
  end
end