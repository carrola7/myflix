# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 5.times do 
#   Video.create(title: 'Family Guy', 
#                description: "Family Animation", 
#                image_url_large: "https://via.placeholder.com/665x375", 
#                image_url_small: "/tmp/family_guy.jpg")

#   Video.create(title: 'Futurama', 
#                description: "Family robot based animation", 
#                image_url_large: "https://via.placeholder.com/665x375", 
#                image_url_small: "/tmp/futurama.jpg")
               
#   Video.create(title: 'Monk', 
#                description: "Never heard of it", 
#                image_url_large: "/tmp/monk_large.jpg", 
#                image_url_small: "/tmp/monk.jpg")

#   Video.create(title: 'South Park', 
#                description: "Not so family animation", 
#                image_url_large: "https://via.placeholder.com/665x375", 
#                image_url_small: "/tmp/south_park.jpg")
# end

Category.create(name: "Comedy")
Category.create(name: "Animation")
Category.create(name: "Family")
