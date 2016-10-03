# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(email: "admin@g.c", admin: true, password: "123456", password_confirmation: "123456")
10.times { |n| User.create!(email: "member#{n}@g.c", password: "123456", password_confirmation: "123456") }
