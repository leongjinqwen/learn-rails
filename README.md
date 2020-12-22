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