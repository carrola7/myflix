class CreatePasswordRequests < ActiveRecord::Migration
  def change
    create_table :password_requests do |t|
      t.string :email
      t.string :token
      t.integer :user_id
      t.timestamps
    end
  end
end
