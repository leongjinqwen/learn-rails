# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Notes
1.  Type `rails` in the terminal to checkout common rails commands.
    ```bash
    rails new <project_name>    #Create a new Rails application.
    rails server  (alias `s`)   #Start the Rails server, visit the app at `http://localhost:3000` or `http://127.0.0.1:3000`
    rails console (alias `c`)   #Start the Rails console
    rails generate (alias `g`)  #Generate new code
    rails routes                #Show all routes
    ```

1.  Common database rake tasks (https://jacopretorius.net/2014/02/all-rails-db-rake-tasks-and-what-they-do.html)
    ```bash
    db:create           #Creates the database for the current RAILS_ENV environment
    db:drop             #Drops the database for the current RAILS_ENV environment
    db:migrate          #Runs migrations for the current environment that have not run yet
    db:seed             #Runs the db/seeds.rb file
    db:setup            #Runs db:create, db:schema:load and db:seed
    db:reset            #Runs db:drop and db:setup.
    db:migrate:reset    #Runs db:drop, db:create and db:migrate.
    db:migrate:status   #Displays the current migration status.
    ```

1.  Create ArticlesController and its index action, `--skip-routes` option if you want to add routes yourself.
    ```bash
    rails generate controller Articles index --skip-routes
    ```

1.  `Model` is a Ruby class that is used to represent data and can interact with the application's database through `Active Record`.
    ```bash
    rails generate model Article title:string body:text
    ```
    Migration file will be created and used to alter the structure of database, but not make changes to the database until you run `rails db:migrate` in terminal.

1.  URL and path helper in `erb`
    Use `resources` method to map all of the conventional routes of a collection of resources.
    ```rb
    Rails.application.routes.draw do
      root "articles#index"
      resources :articles # The resources method also sets up URL and path helper methods
    end
    ```
    Then run `rails routes` to inspect all routes in the application. The values in the "Prefix" column plus a suffix of `_url` or `_path` form the names of these helpers.
    ```html
    <a href="<%= article_path(article) %>">
      <%= article.title %>
    </a>
    <!-- OR use link_to helper -->
    <%= link_to article.title, article %> 
    <!-- first argument as the link's text, second argument as the link's destination -->
    ```
    The `link_to` helper renders a link with its first argument as the link's text and its second argument as the link's destination.

1.  Submit form data
    ```rb
    @article = Article.new(title: params[:article][:title], body: params[:article][:body])
    ```
    The code above can get the form data, but that would be verbose and possibly error-prone, that would become worse as we add more fields. Instead, we will pass a Hash that contains the values. If we pass the unfiltered `params[:article]` Hash directly to `Article.new`, Rails will raise `ForbiddenAttributesError`. So, we will use `Strong Parameters` to filter params. Add it as a private method in the controller. 
    ```rb
    private
    def article_params
      params.require(:article).permit(:title, :body)
    end
    ```
    Then we can pass the `article_params` directly to `Article.new`.
    ```rb
    @article = Article.new(article_params)
    ```

1.  Validations
    Validations are rules that are checked before a model object is saved. If any of the checks fail, error messages will be added to the errors attribute of the model object. Validations are added to the model in `app/models/article.rb`.
    ```rb
    class Article < ApplicationRecord
      validates :title, presence: true
      validates :body, presence: true, length: { minimum: 10 }
    end
    ```
    To display the error messages, make changes to each form field in html.erb
    ```html
    <% @article.errors.full_messages_for(:title).each do |message| %>
      <div><%= message %></div>
    <% end %>
    ```
    `full_messages_for` return an array of user-friendly error messages for a specified attribute.

1.  Add a new model that have relationship with `Article` model
    ```bash
    rails generate model Comment commenter:string body:text article:references
    ```
    `:reference` keyword is a special data type for models. It creates a new column on your database table with the provided model name appended with an `_id` that can hold integer values (foreign key). Now each comment must `belongs_to` one article, and one article can `has_many` comments. 

1.  Add routes for comments. Code below make comments as a nested resource within articles.
    ```rb
    Rails.application.routes.draw do
      root "articles#index"

      resources :articles do
        resources :comments
      end
    end
    ```

1.  Form for create new comment for article
    ```html
    <%= form_with model: [ @article, @article.comments.build ] do |form| %>
      ...
    <% end %>
    ```
    The `form_with` call here uses an `array`, which will build a nested route, such as `/articles/1/comments`

1.  Concerns(mixin) make large controllers or models easier to understand and manage. This also has the advantage of reusability when multiple models (or controllers) share the same concerns.

1.  Deleting associated objects - when delete an article which has many comments, you want to delete all comments at the same time, use `dependent` option on the foreign key in `Article` model. (on_delete=cascade)
    ```rb
    has_many :comments, dependent: :destroy
    ```

## ActiveRecords
Rails Active Record is the Object/Relational Mapping (ORM) layer supplied with Rails. Each Active Record object has CRUD (Create, Read, Update, and Delete) methods for database access.  
(https://guides.rubyonrails.org/active_record_basics.html)
1.  Create
    ```rb
    #create and save into database at the same time
    user = User.create(name: "will", email: "will@email.com") 
    #new method
    user = User.new
    user.name = "will"
    user.email = "will@email.com"
    user.save
    #both methods return the new object
    ```

1.  Read (https://guides.rubyonrails.org/active_record_querying.html)
    ```rb
    user = User.find(10)    #Find user with primary key (id) 10, raise RecordNotFound exception if no matching record (get_by_id)
    users = User.find([10, 13]) # OR User.find(10, 13) => return an array of matching records from provided ids 

    user = User.take        #retrieves a record without any implicit ordering, returns `nil` if no record is found (get_or_none)
    users = User.take(2)    #equivalent to => SELECT * FROM user LIMIT 2
    user = User.take!       #behave like `take` but will raise RecordNotFound exception if no matching record

    user = User.first       #finds the first record ordered by primary key (default), returns `nil` if no record is found
    users = User.first(3)   #return an array up to that number of results
    user = User.first!      #behave like `first` but will raise RecordNotFound exception if no matching record
    user = User.order(:name).first

    user = User.last 
    user = User.order(:name).last

    user = User.find_by(name: 'will')   # OR User.find_by name: 'will' => finds the first record matching conditions, `nil` if not found
    user = User.where(name: 'will').take  #get same result as using `find_by`
    user = User.find_by!(name: 'will')   #raise RecordNotFound
    ```
    Iterate over large set of records
    ```rb
    User.all.each do |u|
      Mailer.send_reminder(u)
    end
    ```
    Code above will instruct Active Record fetch the entire table in a single pass, build a model object per row, and then keep the entire array of model objects in memory. The entire collection may exceed the amount of memory available.  
    The `find_each` and `find_in_batches` methods are intended for use in the batch processing of a large number of records that wouldn't fit in memory all at once. If you just need to loop over a thousand records the regular find methods are the preferred option.

1.  Update
    ```rb
    #get the user from db
    user = User.find_by(name: 'will')
    # 1. reassign value
    user.name = 'john'
    user.save
    # 2. use update method (useful for updating several attributes at once)
    user.update(name: 'john')

    #update several records in bulk
    User.update_all "name='john', email='john@email.com'"
    ```

1.  Delete
    ```rb
    #delete single record
    user = User.find_by(name: 'will')
    user.destroy

    #delete several records in bulk
    User.destroy_by(name: 'David')   #find and delete all users named David
    User.destroy_all        #delete all users
    ```

## Set Up Rails with Postgres
1.  Installing requirements
    ```bash
    gem install pg
    ```

1.  Add `pg` to Gemfile
    ```rb
    gem 'pg', '>= 0.18', '< 2.0'
    ```

1.  Make changes to `database.yml`
    ```yml
    default: &default
      adapter: postgresql
      encoding: unicode
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

    development:
      <<: *default
      database: rubyblog_development

    test:
      <<: *default
      database: rubyblog_test

    production:
      <<: *default
      database: rubyblog_production
      username: rubyblog
      password: <%= ENV['RUBYBLOG_DATABASE_PASSWORD'] %>
    ```

1.  Create and migrate new database
    ```
    rails db:create
    rails db:migrate
    ```

1.  When switch from SQLite to Postgres, getting error caused by PG, `UndefinedTable: ERROR:  relation "users" does not exist`. Because first migration reference to `users` table that only created in third migration file.  
`Solution`: Change the migration file timestamp(filename) to timestamp earlier than first migration file. When run migration, it will run the migration file followed by the timestamp, so that the `users` table will be created before the other tables that reference to it. 

## Setup Env Variables
Run `EDITOR="code --wait" rails credentials:edit` to view/modify environment variables

## User authentication
(https://hackernoon.com/building-a-simple-session-based-authentication-using-ruby-on-rails-9tah3y4j)  

1.  Add `bcrypt` in Gemfile to store password hashes in the database
    ```
    gem 'bcrypt', '~> 3.1.7'
    ```

1.  Install dependencies
    ```bash
    bundle install
    ```

1.  Generate model and controller for User
    ```bash
    rails generate model User name:string email:string password_digest:string

    rails db:migrate

    rails generate controller Users
    ```

1.  Add `has_secure_password` method to user model. `has_secure_password` adds two fields to model: `password` and `password_confirmation`. These fields don't correspond to database columns! Instead, the method expects there to be a `password_digest` column defined in migrations. 
    ```rb
    class User < ApplicationRecord
      has_secure_password
    end
    ```
    `has_secure_password` also adds some `before_save` hooks to model. These compare `password` and `password_confirmation`. If they match (or if `password_confirmation` is nil), then it updates the `password_digest` column.
    

## Admin Interface
1.  Add gem into Gemfile
    ```
    gem 'activeadmin'
    gem 'devise' 
    ```
    `Devise` is a Gem that handles authentication for Rails.

1.  Generate `ActiveAdmin` class to use with Devise. A new `admin_users` table and `active_admin_comments` table will be created once database migrated.
    ```bash
    rails generate active_admin:install
    rails db:migrate
    ```
    But now no admin user created in the database yet, go to `db/seed.rb` then amend the admin user's email and password that you wish to use to login the admin dashboard. Run `rails db:seed`. Now you can login the admin dashboard at `http://localhost:3000/admin`.
    ```rb
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
    ```

1.  Register our models with Active Admin
    ```bash
    rails generate active_admin:resource <model_name>
    rails generate active_admin:resource User
    rails generate active_admin:resource Article
    rails generate active_admin:resource Comment
    ```
    Because activeadmin by default come with an `active_admin_comments` table, which having the same route name with the `Comment` model in the admin dashboard, so we need to register the `Comment` model as another name `Article_Comments`.
    ```rb
    # app/admin/comments.rb
    ActiveAdmin.register Comment, as: "Article_Comments" do
      ...
    end
    ```

1.  After install activeadmin, the styling of the entire app using the activeadmin css, to avoid pages beside admin dashboard using the activeadmin's stylesheet, remove this line from `app/assets/stylesheets/application.css`.
    ```
    *= require_tree .
    ```
    Here is some admin themes that can be installed (https://github.com/activeadmin/activeadmin/wiki/Themes)
