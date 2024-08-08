# frozen_string_literal: true

class NotificationService
  class << self
    def callback(msg)
      task = Task.find(msg[:task_id])
      task.update(scraping_brand: msg[:scraping_brand], scraping_model: msg[:scraping_model],
                  scraping_price: msg[:scraping_price], status: msg[:task_status], notification_date: msg[:updated_at])
    end
  end
end
