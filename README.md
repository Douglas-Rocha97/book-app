📖 Barber-Book
The Barber-Book is a web application designed to make appointment scheduling easier for barbershops and their clients. Clients can quickly book services, while barbers and shop owners can view, organize, and keep track of all appointments through a calendar and date-based filters.

This project was built mainly to learn and practice authorization logic, something I had not implemented in real projects before.

🚀 Technologies Used
Ruby on Rails

PostgreSQL

JavaScript

Bootstrap

📦 Installation
Follow the steps below to run the project locally:

bash
# Clone the repository or fork it
git clone <repository-link>

# Enter the project folder
cd barber-book

# Install dependencies
bundle install

# Create the database
rails db:create

# Run the migrations
rails db:migrate

# Seed the database with default data
rails db:seed
👤 Seed Accounts
User accounts (clients):

diego@example.com | password: 123456

giovanni@example.com | password: 123456

Owner account (barber / admin):

douglas@example.com | password: 123456

▶️ Running the Project
Start the Rails server:

bash
rails s
Then access the app at: http://localhost:3000

📌 Features
✔️ Clients can book appointments

✔️ Staff and owners can track appointments by date

✔️ Calendar-based scheduling interface

✔️ Role-based authorization (client, staff, owner)

✔️ Seed data for quick testing

✔️ Simple and clean Bootstrap interface

🎯 Learning Goals
This project was created to practice:

Authorization in Rails (role-based access control)

Model associations

Permission management across different user roles

👤 Author
Douglas Rocha 🔗 LinkedIn 🌐 Portfolio
