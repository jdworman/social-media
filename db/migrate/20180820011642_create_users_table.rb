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
    add_index :users, :email, unique: true
  end
end

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.string :image_url
      t.datetime :datetime
    end
  end
end
