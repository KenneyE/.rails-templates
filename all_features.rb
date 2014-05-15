# all-features-template.rb

# Includes and configures for rspec testing

# Helpful links:

# Templates doc
# http://guides.rubyonrails.org/rails_application_templates.html

# Generator docs - in particular section 9
# http://guides.rubyonrails.org/generators.html


#----------------------------
## database.yml
#----------------------------
old_yml = Regexp.new("^(.*){1}", Regexp::IGNORECASE | Regexp::MULTILINE)

new_yml = <<-NEW
development:
  adapter: postgresql
  database: #{@app_name}_dev
  host: localhost
  pool: 5
  timeout: 5000

test:
  adapter: postgresql
  database: #{@app_name}_test
  host: localhost
  pool: 5
  timeout: 5000

production:
  adapter: postgresql
  database: #{@app_name}_prod
  host: localhost
  pool: 5
  timeout: 5000
NEW

gsub_file 'config/database.yml', old_yml, new_yml

#----------------------------
## GEMS
#----------------------------
gsub_file 'Gemfile', "gem 'sqlite3'", ""

gem 'bcrypt'
gem 'pg'
gem 'pry-rails'
gem 'devise'
gem 'backbone-on-rails'
gem 'jbuilder'
gem 'ejs'

gem 'bootstrap-sass'


gem_group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

gem_group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'faker'
end

run "bundle install"

#-------------------
## devise
#-------------------
generate "devise:install"

inject_into_file './config/environments/development.rb', after: "DeviseTest::Application.configure do\n" do
  "  config.action_mailer.default_url_options = { host: 'localhost:3000' }\n"
end

inject_into_file './app/views/layouts/application.html.erb', after: "<body>\n" do
  "  \n<p class=\"notice\"><%= notice %></p>\n<p class=\"alert\"><%= alert %></p>\n"
end

route "root to: 'home#index'"
# generate "devise User"

#----------------------------
## rake
#----------------------------
puts("------------------------------------------------------------------")
puts("------------------------------------------------------------------")
if yes?("Create DB? ('y' only if psql is running):")
  rake("db:create:all")
  rake("db:migrate")
  rake("db:test:prepare")
end


#-------------------
## bootstrap
#-------------------

run "mv ./app/assets/stylesheets/application.css ./app/assets/stylesheets/application.css.scss"

append_to_file "./app/assets/stylesheets/application.css.scss", "\n@import \“bootstrap\";\n"
append_to_file "./app/assets/javascripts/application.js", "\n//= require bootstrap\n"
header_text = <<-HEADER
  <%= stylesheet_link_tag 'application' %>
  <%= javascript_include_tag 'application' %>
  <%= csrf_meta_tags %>
HEADER

inject_into_file "./app/views/layouts/application.html.erb", after: "</title>\n" do
  header_text
end


#----------------------------
## Backbone
#----------------------------
generate "backbone:install --javascript"
generate "backbone:scaffold #{@app_name} --javascript"

#----------------------------
## Rspec and Factories
#----------------------------
generate "rspec:install"
append_to_file '.rspec', '--format documentation'


inject_into_file './config/application.rb', after: "class Application < Rails::Application\n" do <<-'RUBY'
    config.generators do |g|
    g.test_framework :rspec,
      :fixtures => true,
      :view_specs => false,
      :helper_specs => false,
      :routing_specs => false,
      :controller_specs => true,
      :request_specs => true
    g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
RUBY
end

inject_into_file './spec/spec_helper.rb', after: "RSpec.configure do |config|\n" do
  "  config.include FactoryGirl::Syntax::Methods\n"
end

run 'mkdir ./spec/factories/'

#----------------------------
## git
#----------------------------
git :init
append_to_file '.gitignore', ".DS_Store\nconfig/database.yml\n.env\n"
git add: "-A"
git commit: %Q{ -m 'Initial commit' }
run "mate ."