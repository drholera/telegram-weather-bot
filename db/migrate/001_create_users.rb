class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, force: true do |t|
      t.integer :uid
      t.integer :chat_id
      t.boolean :enabled, :default => false
      t.string :city
    end
  end
end