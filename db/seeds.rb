require 'faker'


5.times do
  user = User.new(
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  email: Faker::Internet.email,
  birthday: Faker::Date.birthday
)
user.save
end

User.all.each do |m|
20.times do
  posts = Post.new(
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  title: Faker::WorldCup.city,
  content: Faker::BackToTheFuture.quote,
  user_id: m.id
)
    posts.save
  end
end
