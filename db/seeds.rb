# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


Category.create(name: "Comedy")
Category.create(name: "Animation")
Category.create(name: "Family")

Category.all.each do |category|
  Video.create(title: 'Family Guy', 
    description: "Family Animation", 
    image_url_large: "https://via.placeholder.com/665x375", 
    image_url_small: "/tmp/family_guy.jpg",
    category_id: category.id)

  Video.create(title: 'Futurama', 
      description: "Family robot based animation", 
      image_url_large: "https://via.placeholder.com/665x375", 
      image_url_small: "/tmp/futurama.jpg",
      category_id: category.id)
      
  Video.create(title: 'Monk', 
      description: "Never heard of it", 
      image_url_large: "/tmp/monk_large.jpg", 
      image_url_small: "/tmp/monk.jpg",
      category_id: category.id)

  Video.create(title: 'South Park', 
      description: "Not so family animation", 
      image_url_large: "https://via.placeholder.com/665x375", 
      image_url_small: "/tmp/south_park.jpg",
      category_id: category.id)
end

10.times do |n|
  User.create(email: "user_#{n}@gmail.com",
              password: "password",
              full_name: Faker::Name.name)
end

User.create(name: 'Adrian Carroll',
            email: 'adrian.carroll7@gmail.com',
            password: 'qwerty')

users = User.all
target_users = users[1..2]
target_users.each do |user|
  following = users[2..15]
  followers = users[3..10]
  following.each { |followed| user.follow(followed) }
  followers.each { |follower| follower.follow(user) }
end


