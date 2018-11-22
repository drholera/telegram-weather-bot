class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, force: true do |t|
      t.integer :chat_id
      t.boolean :enabled, :default => false
      t.string :city
      t.boolean :schedule_enabled, :default => false
      t.timestamp :forecast_time
    end
  end
end