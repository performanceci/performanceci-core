source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# PostgreSQL for production
gem 'pg'
#, group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


#=========================================
#gem "active_model_serializers"
gem 'devise', '3.1.0'
gem 'execjs'
gem 'therubyracer', :platforms => :ruby

# Docker
gem 'docker-api', :require => 'docker'
gem 'git'

gem 'dotenv-rails', :groups => [:development, :test]

# upgrading to newer versions of these gems caused new github accounts to not be able to
# sign in / create an account on our side
gem 'oauth2'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-github'
gem "octokit", "~> 2.7.1"
gem "heroku-api"

gem 'angularjs-rails'

#gem 'bcrypt', :require => "bcrypt"

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.1.2', :require => "bcrypt"

gem 'resque'
gem 'resque-status'

gem 'seed_dump'

group :test, :development do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# Use unicorn as the app server
# gem 'unicorn'

# Use uwsgi as the application server
gem 'uwsgi'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
