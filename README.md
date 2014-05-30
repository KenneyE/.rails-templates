Rails Templates
===============

I've been working on putting together a collection of useful Rails templates to get up and running with certain Rails features.  As nice as all of the available gems are, there is often separate configuration required. The idea here is to give one template to do all configuration for a given set of features.  

The idea here isn't to make creating a new Rails app really fast, because you probably don't do it enough for that to be worthwhile.  It's really so that you can generate and app and be confident that all of the configuration has been taken care of. If you find any bugs, which I'm sure there are, let me know or submit a pull request.

Here's what we've got so far.

## Usage Examples
To use these templates, you can either clone the repository to a local directory or use the GitHub URL to the raw text version.  

##### Cloning To Local Repo:

    $ git clone git@github.com:KenneyE/.rails-templates.git rails-templates
    $ cd <wherever you want the app>
    $ rails new <app-name> -m ~/path/to/template.rb

For example, if you were to use the `devise` template, you would run

    $ rails new devise-app -m ~/rails-templates/devise_template.rb

##### Using Raw Text URL:

Go to https://github.com/KenneyE/.rails-templates and click the template you'd like to use. Then click the `Raw` button and copy the resulting URL.

    $ rails new <app-name> -m <template-url>

---

#### Templates using test framework:

#####NOTE:

If you are using any of the templates that build a test framework for you, make sure to include the `-T` tag to tell Rails not to include the default test framework. The above examples would then look like...

    $ rails new <app-name> -T -m ~/path/to/test_template.rb


## Current Templates

All templates add a few useful features like `binding_of_caller`, `better_errors`, `pry-rails`, `annotate`, and convert the database to postgres. **That is IMPORTANT**

They also all run `bundle install` and then run

    git init
    git add -A
    git commit -m "Initial commit"

### Test Template

Includes these gems in the test environment:

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

To use:

    $ rails new test-app -T -m ~/.rails-templates/test_template.rb

### Devise Template
Adds devise gem and runs `rails generate devise:install`. Adds some stuff to `development.rb`

To use:

    $ rails new test-app -m ~/.rails-templates/devise_template.rb

### Backbone Template

Adds gems:

    gem 'backbone-on-rails'
    gem 'ejs'

and runs:

rails generate "backbone:install --javascript"
rails generate "backbone:scaffold #{@app_name} --javascript"

### Bootstrap Template

Adds gem `bootstrap-sass` and adds necessary stuff to `./app/assets/stylesheets/application.css.scss`

$ rails new test-app -m ~/.rails-templates/bootstrap_template.rb


### Combo Templates

There's also a handful of templates that have various combinations of these features. Pick and choose accordingly.
