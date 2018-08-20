class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    t.string 'email'
    t.string 'password_hash'
    t.string 'firstname'
    t.string 'lastname'
    t.datetime 'birthday'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end
  end
end
