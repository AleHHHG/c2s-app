class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :url
      t.integer :status, default: 0
      t.datetime :notification_date, default: nil
      t.integer :user_id
      t.string :scraping_brand
      t.string :scraping_model
      t.decimal :scraping_price
      t.timestamps
    end
  end
end
