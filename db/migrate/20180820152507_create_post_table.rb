class CreatePostTable < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :user_name
      t.string :image_url
      t.datetime :datetime
  end
    add_index :users, :email, unique: true
  end
end
