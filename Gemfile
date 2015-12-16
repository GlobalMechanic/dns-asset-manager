source 'https://rubygems.org'

gem 'rails', '3.2.11'

gem 'pg'
gem 'json'
gem 'airbrake'
gem 'newrelic_rpm'
gem 'delayed_job_active_record'

# Auth
gem 'devise'
gem 'rolify'
gem 'cancan'

# Controllers
gem 'acts_as_indexed'
gem 'rubyzip', :require => 'zip/zip'
gem 'kaminari' # For pagination

# Models
gem 'inherited_resources'
gem 'paper_trail'
gem 'acts-as-taggable-on', '~> 2.3.3'
gem 'carrierwave'
gem 'fog', '~> 1.3.1'
gem 'paperclip'
gem 'mini_magick'

# Frontend
gem 'asset_sync'
gem 'zeroclipboard-rails'
gem 'underscore-rails'
gem 'simple_form'
#gem 'rails3-jquery-autocomplete'
git 'git://github.com/edsimpson/rails3-jquery-autocomplete.git', :branch => 'jquery-1-9-compat' do
  gem 'rails3-jquery-autocomplete'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-fileupload-rails'
end

gem 'jquery-rails'
gem 'skeleton-rails'

group :test do
  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
  gem 'rspec-rails'
end

group :development do
  gem 'pry-rails'
  # gem 'railroady'
end
