# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Cleaning data base..."
 Appointment.destroy_all
 ProfessionalService.destroy_all
 Service.destroy_all
 Professional.destroy_all
 User.destroy_all

puts "creating accounts..."

user1 = User.create!(
  name: "Douglas",
  gender: "male",
  email: "douglas@example.com",
  password: "123456",
  role: :owner,
  number: "080-3509-2343"
)

user1.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)

user2 = User.create!(
  name: "Giovanni",
  gender: "male",
  email: "giovanni@example.com",
  password: "123456",
  role: :staff,
  number: "090-3509-9999"
)

user2.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)

user3 = User.create!(
  name: "Diego",
  gender: "male",
  email: "diego@example.com",
  password: "123456",
  role: :user,
  number: "070-3509-0099"
)

user3.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)

puts "creating professionals..."
prof1 = Professional.create!(
  name: "Giovanni",
  role: "barber",
  start_at: "09:00",
  finish_at: "18:00",
  date: Date.today
)

prof1.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)

prof2 = Professional.create!(
  name: "Willian",
  role: "barber",
  start_at: "09:00",
  finish_at: "18:00",
  date: Date.today
)

prof2.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)

prof3 = Professional.create!(
  name: "Ingrid",
  role: "barber",
  start_at: "09:00",
  finish_at: "18:00",
  date: Date.today
)

prof3.photo.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)

puts "creating services..."
service1 = Service.create!(
  name:"haircut",
  price: 3800,
  duration: 45
)

service2 = Service.create!(
  name:"beard trimm",
  price: 2000,
  duration: 30
)

service3 = Service.create!(
  name:"Hair coloring",
  price: 10000,
  duration: 120
)

service4 = Service.create!(
  name:"Eyebrow shaping",
  price: 1800,
  duration: 20
)

puts "Associating services to professionals..."
ProfessionalService.create!(professional: prof1, service: service1)
ProfessionalService.create!(professional: prof1, service: service2)
ProfessionalService.create!(professional: prof2, service: service1)
ProfessionalService.create!(professional: prof3, service: service1)
ProfessionalService.create!(professional: prof3, service: service2)
ProfessionalService.create!(professional: prof3, service: service3)
ProfessionalService.create!(professional: prof3, service: service4)


puts "Creating appointments..."
appointment1 = Appointment.create!(
  user: user1,
  professional: prof1,
  date: Date.today + 1,
  start_time: "10:00",
  finish_time: "10:45",
  service_ids: [service1.id, service2.id]
)

appointment1.goal_image.attach(
  io: File.open(Rails.root.join("app/assets/images/userSeed.jpg")),
  filename: "userSeed.jpg",
  content_type: "image/jpeg"
)


puts "Successfully seeded!"
