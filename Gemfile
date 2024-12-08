# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# CONFIGURATION
gem 'figaro', '~> 1.2'
gem 'pry'
gem 'rake', '~> 13.2', '>= 13.2.1'

# PRESENTATION LAYER
gem 'erb', '~> 4.0', '>= 4.0.4'
gem 'htmlbeautifier'

# APPLICATION LAYER
# Web application related
gem 'logger', '~> 1.6', '>= 1.6.1'
gem 'puma', '~> 6.4', '>= 6.4.3'
gem 'rack-session', '~> 2.0'
gem 'roda', '~> 3.85'
gem 'tilt'

# Controllers and services
gem 'dry-monads', '~> 1.6'
gem 'dry-transaction', '~> 0.16.0'
gem 'dry-validation', '~> 1.10'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1.6'
gem 'dry-types', '~> 1.7', '>= 1.7.2'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5.2'

# Database
gem 'hirb'
# gem 'hirb-unicode' # incompatible with new rubocop
gem 'sequel', '~> 5.0'

group :development, :test do
  gem 'sqlite3', '~> 1.0'
end

group :production do
  gem 'pg', '~> 1.5', '>= 1.5.9'
end

# Testing
group :test do
  # Unit/Integration/Acceptance Tests
  gem 'minitest', '~> 5.20'
  gem 'minitest-rg', '~> 5.2'
  gem 'simplecov', '~> 0.22.0'
  gem 'vcr', '~> 6.3', '>= 6.3.1'
  gem 'webmock', '~> 3.24'

  # Acceptance Tests
  gem 'headless', '~> 2.3', '>= 2.3.1'
  gem 'page-object', '~> 2.3', '>= 2.3.1'
  gem 'selenium-webdriver', '~> 4.26'
  gem 'watir', '~> 7.3'
end

# Development
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-rake'
  gem 'rubocop-sequel'
end

gem 'rackup', '~> 2.2'
gem 'sinatra'

# API
gem 'google_distance_matrix', '~> 0.7.0'
gem 'google-maps', '~> 3.0', '>= 3.0.7'
