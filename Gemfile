source 'https://rubygems.org'


gem 'rails', '4.1.5'
gem 'mysql'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
#gem 'unicorn'

gem 'capistrano-rails', group: :development
#gem 'debugger', group: [:development, :test]

gem 'devise'
gem 'devise-encryptable'
gem 'wiscale'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'skylight'

group :development do
  gem 'capistrano3-unicorn'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
end

group :production, :staging do
  gem 'unicorn'
end
