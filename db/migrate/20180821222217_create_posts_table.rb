class CreatePostsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :firstname
      t.string :lastname
      t.string :image_url
      t.datetime 'created_at'
  end
  end
end
