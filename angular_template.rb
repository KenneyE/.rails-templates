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

#----------------------------
## Angular
#----------------------------
run "curl 'https://code.angularjs.org/1.1.5/angular.js' -o 'app/assets/javascripts/angular.js'"
run "curl 'https://code.angularjs.org/1.1.5/angular-mocks.js' -o 'app/assets/javascripts/angular-mocks.js'"

gsub_file('app/assets/javascripts/application.js',
            "//= require turbolinks",
            "//= require angular\n//= require main"
          )

gsub_file('app/views/layouts/application.html.erb',
            ", 'data-turbolinks-track' => true",
            ""
          )

gsub_file('app/views/layouts/application.html.erb',
            "<html>",
            "<html ng-app=\"#{@app_name}\">"
            )

gsub_file('app/views/layouts/application.html.erb',
            "<%= yield %>",
            "<div ng-view>\n  <%= yield %>\n</div>"
          )

run "mkdir -p app/assets/javascripts/angular/controllers"

#-------------------
## git
#-------------------
git :init
append_to_file '.gitignore', ".DS_Store\nconfig/database.yml\n.env\n"
git add: "-A"
git commit: %Q{ -m 'Initial commit' }
run "mate ."