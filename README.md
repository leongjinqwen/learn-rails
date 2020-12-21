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

1. Type `rails` in the terminal to checkout common rails commands.
    ```bash
    rails new <project_name>    #Create a new Rails application.
    rails server  (alias `s`)   #Start the Rails server, visit the app at `http://localhost:3000` or `http://127.0.0.1:3000`
    rails console (alias `c`)   #Start the Rails console
    rails generate (alias `g`)  #Generate new code
    ```

1. Create ArticlesController and its index action, `--skip-routes` option if you want to add routes yourself.
    ```bash
    rails generate controller Articles index --skip-routes
    ```

1. `Model` is a Ruby class that is used to represent data and can interact with the application's database through `Active Record`.
    ```bash
    rails generate model Article title:string body:text
    ```
    Migration file will be created and used to alter the structure of database, but not make changes to the database until you run `rails db:migrate` in terminal.