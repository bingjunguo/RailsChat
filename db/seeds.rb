# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# test by zhangfei and peng


(1..100).each do |index|
  User.create(
      name: "user#{index}",
      email: "user#{index}@test.com",
      password: 'password',
      role: Faker::Number.between(1, 4),
      sex: ['male', 'female'].sample,
      phonenumber: Faker::PhoneNumber.phone_number,
      status: Faker::Company.profession,
      activated: true,
      activated_at: Time.zone.now
  )
end

User.create!(name:  "admin",
             email: "admin@test.com",
             password:              "123456",
             password_confirmation: "123456",
             role: 1,
				     sex: "male",
				     phonenumber: "88888888",
             status: "admin",
             activated: true,
             activated_at: Time.zone.now,
             admin: true)

# 为前6个用户添加微博
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end             	

User.first.friendships.create(:friend_id => 2)
User.first.friendships.create(:friend_id => 3)

User.first.friendships.create(:friend_id => 101)
User.second.friendships.create(:friend_id => 101)


  