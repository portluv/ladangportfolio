# README

Rails installer site:
http://railsinstaller.org/en

Click this link to download compatible rails version:
https://s3.amazonaws.com/railsinstaller/Windows/railsinstaller-3.4.0.exe

Version:
Ruby 2.3.3
Rails 5.1
Bundler 2

Database creation:
1. Install postgres
2. Create database name ladangportfolio_dev
3. Update database credentials on database.yml

To initialize Database:
rails db:migrate

To install dependencies:
bundle install

To run application:
rails server