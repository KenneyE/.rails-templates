# template.rb

# Helpful links:

# Templates doc
# http://guides.rubyonrails.org/rails_application_templates.html

# Generator docs - in particular section 9
# http://guides.rubyonrails.org/generators.html


#-------------------
## database.yml
#-------------------
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



#-------------------
## GEMS
#-------------------

gsub_file 'Gemfile', "gem 'sqlite3'", ""

gem 'bcrypt'
gem 'pg'
gem 'pry-rails'
gem 'backbone-on-rails'
# gem 'jbuilder'
gem 'ejs'
gem 'bootstrap-sass'

gem_group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
end

run "bundle install"


#-------------------
## rake
#-------------------
puts("------------------------------------------------------------------")
puts("------------------------------------------------------------------")
rake("db:create:all") if yes?("Create DB? ('y' only if psql is running):")


#-------------------
## bootstrap
#-------------------

run "mv ./app/assets/stylesheets/application.css ./app/assets/stylesheets/application.css.scss"

append_to_file "./app/assets/stylesheets/application.css.scss", "\n@import \"bootstrap\";\n"
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

#-------------------
## git
#-------------------
git :init
append_to_file '.gitignore', ".DS_Store\nconfig/database.yml\n.env\n"
git add: "-A"
git commit: %Q{ -m 'Initial commit' }
run "mate ."