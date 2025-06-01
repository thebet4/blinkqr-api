class CreateAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :analytics do |t|
      t.references :link, null: false, foreign_key: true
      t.string :ip_address, null: true 
      t.string :user_agent, null: true
      t.string :referrer, null: true
      t.string :country, null: true
      t.string :city, null: true
      t.string :device_type, null: true
      t.string :os, null: true
      t.string :browser, null: true
      t.string :browser_version, null: true
      t.string :browser_language, null: true
      t.timestamps
    end
  end
end
