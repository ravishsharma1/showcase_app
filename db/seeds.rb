# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding database..."

# --- Categories ---
categories = %w[Design Development Marketing Business Writing Data]
category_records = categories.map do |name|
  Category.find_or_create_by!(name: name)
end

# --- Users ---
admin = User.find_or_create_by!(email: "admin@workhub.dev") do |u|
  u.name = "Admin User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :admin
end

client = User.find_or_create_by!(email: "client@workhub.dev") do |u|
  u.name = "Client User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :client
end

freelancer = User.find_or_create_by!(email: "user@workhub.dev") do |u|
  u.name = "Freelancer User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :user
end

# Additional users
users = [ admin, client, freelancer ]
10.times do |i|
  users << User.find_or_create_by!(email: "user#{i + 1}@workhub.dev") do |u|
    u.name = Faker::Name.name
    u.password = "password123"
    u.password_confirmation = "password123"
    u.role = %i[user client].sample
  end
end

# --- Companies (owned by clients) ---
clients = users.select(&:client?)
companies = []
clients.each do |owner|
  2.times do
    companies << Company.find_or_create_by!(name: Faker::Company.name, user: owner) do |c|
      c.description = Faker::Company.catch_phrase
      c.website = Faker::Internet.url
    end
  end
end

# --- Jobs ---
companies.each do |company|
  5.times do
    Job.find_or_create_by!(title: Faker::Job.title, company: company) do |job|
      job.description = Faker::Lorem.paragraphs(number: 6).join("\n\n")
      job.location = [ Faker::Address.city, "Remote", "Hybrid" ].sample
      job.salary_min = rand(40_000..80_000)
      job.salary_max = job.salary_min + rand(20_000..60_000)
      job.employment_type = Job.employment_types.keys.sample
      job.status = %i[draft published published published closed].sample
    end
  end
end

# --- Products ---
products = []
users.each do |seller|
  3.times do
    products << Product.find_or_create_by!(name: Faker::Commerce.product_name, user: seller) do |product|
      product.category = category_records.sample
      product.description = Faker::Lorem.paragraphs(number: 3).join("\n\n")
      product.price = Faker::Commerce.price(range: 5.0..200.0)
    end
  end
end

# --- Orders ---
users.each do |buyer|
  3.times do
    order = Order.create!(user: buyer, status: %i[pending paid shipped delivered].sample, total: 0)
    total = 0
    rand(1..3).times do
      product = products.sample
      quantity = rand(1..3)
      price = product.price
      order.order_items.create!(product: product, quantity: quantity, price: price)
      total += price * quantity
    end
    order.update!(total: total)
  end
end

# --- Posts ---
users.each do |author|
  3.times do
    Post.find_or_create_by!(title: Faker::Book.title, user: author) do |post|
      post.category = category_records.sample
      post.body = Faker::Lorem.paragraphs(number: 8).join("\n\n")
      post.published = [ true, true, false ].sample
    end
  end
end

# --- Comments ---
Post.published.each do |post|
  rand(0..4).times do
    Comment.find_or_create_by!(post: post, user: users.sample) do |comment|
      comment.body = Faker::Lorem.sentence(word_count: 12)
    end
  end
end

# --- Projects & Tasks ---
users.each do |owner|
  3.times do
    project = Project.find_or_create_by!(title: Faker::App.name, user: owner) do |p|
      p.description = Faker::Lorem.paragraphs(number: 3).join("\n\n")
      p.status = %i[planning in_progress on_hold completed].sample
    end
    5.times do
      Task.find_or_create_by!(title: Faker::Lorem.sentence(word_count: 4), project: project) do |task|
        task.description = Faker::Lorem.sentence(word_count: 8)
        task.status = %i[todo in_progress done].sample
        task.priority = %i[low medium high urgent].sample
        task.due_date = Faker::Date.forward(days: 30)
        task.user = owner
      end
    end
  end
end

puts "Seeding complete!"
puts "  Admin:      admin@workhub.dev / password123"
puts "  Client:     client@workhub.dev / password123"
puts "  Freelancer: user@workhub.dev / password123"
