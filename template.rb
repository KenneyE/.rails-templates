# template.rb
 
# Helpful links:
 
# Templates doc
# http://guides.rubyonrails.org/rails_application_templates.html
 
# Generator docs - in particular section 9
# http://guides.rubyonrails.org/generators.html
 
#-------------------
## GEMS
#-------------------
 
gsub_file 'Gemfile', "gem 'sqlite3'", ""
 
gem 'bcrypt'
gem 'pg'
gem 'pry-rails'
 
gem_group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
end
 
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
 
# test:
#   adapter: postgresql
#   database: #{@app_name}_test
#   host: localhost
#   pool: 5
#   timeout: 5000
#
# production:
#   adapter: postgresql
#   database: #{@app_name}_prod
#   host: localhost
#   pool: 5
#   timeout: 5000
NEW
 
gsub_file 'config/database.yml', old_yml, new_yml
 
run "bundle install"
 
#-------------------
## rake
#-------------------
puts("------------------------------------------------------------------")
puts("------------------------------------------------------------------")
rake("db:create:all") if yes?("Create DB? ('y' only if psql is running):")
 
 
#-------------------
## git
#-------------------
git :init
append_to_file '.gitignore', '.DS_Store\n'
append_file '.gitignore', 'config/database.yml\n'
append_file '.gitignore', '.env\n'
git add: "-A"
git commit: %Q{ -m 'Initial commit' }
run "mate ."