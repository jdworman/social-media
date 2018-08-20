require 'lorem_ipsum_amet'

User.create(
  email: 'jdworman84@gmail.com',
  password: 'password',
  firstname: 'Joseph',
  lastname: 'Worman',
  birthday: '10/08/1984'
)

User.create(
  email: 'blissend@gmail.com',
  password: 'password',
  firstname: 'Adam',
  lastname: 'Carlin',
  birthday: '10/09/1982'
)

User.create(
  email: 'wishitwas@gmail.com',
  password: 'password',
  firstname: 'Johnny',
  lastname: 'Carson',
  birthday: '10/23/1972'
)

(1..80).each do |_|
  Post.create(
    title: LoremIpsum.w(rand(1..4)),
    content: LoremIpsum.random(paragraphs: rand(1..3)),
    user_id: rand(1..3),
    image_url: 'media/filler.jpg',
    datetime: Time.now
  )
end

 
