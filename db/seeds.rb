# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
  pw = Faker::Internet.password
  User.create!(
    email: Faker::Internet.unique.email,
    password: pw,
    password_confirmation: pw,
    confirmed_at: Time.now
  )
end
users = User.all

50.times do
  Wiki.create!(
    title: Faker::Lorem.unique.sentence,
    body: Faker::Lorem.paragraph,
    user: users.sample
  )
end

admin = User.create!(
  email: 'admin@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  confirmed_at: Time.now,
  role: :admin
)

premium = User.create!(
  email: 'premium@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  confirmed_at: Time.now,
  role: :premium
)

standard = User.create!(
  email: 'standard@example.com',
  password: 'helloworld',
  password_confirmation: 'helloworld',
  confirmed_at: Time.now
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
