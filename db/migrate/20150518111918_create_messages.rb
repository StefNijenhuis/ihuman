class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.string :content
      t.integer :sender_id
      t.integer :scenario_session_id
      t.string :role
      t.datetime :send_at
      t.datetime :read_at

    end
  end
end
