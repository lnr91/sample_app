namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Example User",
                       nick_name: "example",
                       email: "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin) # Here we are making the fist user Admin by default
  99.times do |n|
    name = Faker::Name.name
    nick_name = "#{Faker::Internet.user_name}#{n}"
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,
                 nick_name: nick_name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users=User.all(limit: 6)
  50.times do
    content= Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each do |followed|
    user.follow!(followed)
  end
  followers.each do |follower|
    follower.follow!(user)
  end
end