namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_posts
    make_comments
  end
end

def make_users
  User.create!(:name => "user",
    :email => "user@gmail.com",
    :password => "foobar",
    :password_confirmation => "foobar")
  99.times do |n|
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    password  = "password"
    User.create(:name => name,
      :email => email,
      :password => password,
      :password_confirmation => password)
  end
end

def make_posts
  User.all.each do |user|
    rand(4).times do
      post_tags = Faker::Lorem.sentence(rand(10))
      post_title = Faker::Lorem.sentence(5)
      post_text = Faker::Lorem.paragraphs(10).map{ |p| "<p>#{p}</p>" }.join("\n")
      post = user.posts.create!(:title => post_title, :content => post_text)
      post.add_tags(post_tags)
    end
  end
end

def make_comments
  posts = Post.find(:all)
  #registered users
  User.all.each do |user|
    content = Faker::Lorem.paragraph(5)
    post = posts.sample
    user.comments.create!(:content => content, :post_id => post[:id])
  end
  #anonymous
  100.times do
    content = Faker::Lorem.paragraph(5)
    Comment.create!(:content => content, :post_id => posts.sample[:id])
  end
end