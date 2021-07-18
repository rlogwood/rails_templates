# frozen_string_literal: true

# This is a simple Single Table Inheritance (STI) example
# This template was inspired by
# Single Table Inheritance in Rails 6; Emulating OOP principles in relational databases
# Gene H Fang Nov, 13, 2019
# https://medium.com/@ghl234/single-table-inheritance-in-rails-6-emulating-oop-principles-in-relational-databases-be60c84e0126

DB_SEEDS_CONTENT = <<~'SEEDS'
  Cat.create(name: "Socks", age: 4, breed: "Maine Coone", owner_id: 5)
  Cat.create(name: "Ernie", age: 5, breed: "Egyptian Mau", owner_id: 25)
  Cat.create(name: "Crayon", age: 2, breed: "Short Hair", owner_id: 3)
  Cat.create(name: "Remi", age: 2, breed: "Short Hair", owner_id: 3)
  Dog.create(name: "Emma", age: 10, breed: "Alaskan Husky", owner_id: 1)
  Dog.create(name: "Teapot", age: 1, breed: "Greyhound", owner_id: 12)
SEEDS

NAV_BAR_CSS = <<~CSS
  ul {
      list-style: none;
      display: inline;
      padding-right: 20px;
  }

  li {
      font-weight: bold;
      font-size: 2rem;
      display: inline;
  }

  a:hover {
      background-color: yellow;
      color: black;
  }

  a {
      text-decoration: none;
      background-color: lightcyan;
      color: #333333;
      border-radius: 5px;
      border-color: darkblue;
      border-width: 1px;
      border-style: solid;
      padding: 2px;
  }

  a.selected {
      border-color: black;
      background-color: lightgoldenrodyellow;
      color: darkslategray;
      border-width: 2px;
  }
CSS

NAV_BAR_HTML = <<~'HTML'
  <div id='navbar'>
    <ul>
      <li>
        <%= link_to 'Pets', pets_path, class: "#{selected_action? pets_path}" %>
      </li>
      <li>
        <%= link_to 'Cats', cats_path, class: "#{selected_action? cats_path}" %>
      </li>
      <li>
        <%= link_to 'Dogs', dogs_path, class: "#{selected_action? dogs_path}" %>
      </li>
    </ul>
    <hr/>
  </div>
HTML

NAV_BAR_LAYOUT = <<~LAYOUT
  <%= render partial: "shared/navigation" %>
LAYOUT

APPLICATION_HELPER = <<~RUBY
  def selected_action?(controller)
    'selected' if controller.remove('/') == controller_name
  end
RUBY

DB_SEEDS_FILENAME = 'db/seeds.rb'
NAV_BAR_HTML_FILENAME = 'app/views/shared/_navigation.html.erb'
APPLICATION_LAYOUT_FILENAME = 'app/views/layouts/application.html.erb'
APPLICATION_CSS_FILENAME = 'app/assets/stylesheets/application.css'
APPLICATION_HELPER_FILENAME = 'app/helpers/application_helper.rb'

def generate_scaffolds
  generate :scaffold, 'pet name age breed type owner_id'
  generate :scaffold, 'cat name age breed owner_id', '--parent=Pet --no-migration'
  generate :scaffold, 'dog name age breed owner_id', '--parent=Pet --no-migration'
end

def initialize_db
  create_file(DB_SEEDS_FILENAME, force: true)
  append_to_file(DB_SEEDS_FILENAME, DB_SEEDS_CONTENT)
  rails_command "db:drop"
  rails_command "db:prepare"
end

def create_nav_bar
  create_file(NAV_BAR_HTML_FILENAME, force: true)
  append_to_file(NAV_BAR_HTML_FILENAME, NAV_BAR_HTML)
  insert_into_file(APPLICATION_LAYOUT_FILENAME, after: '<body>') { NAV_BAR_LAYOUT }
  append_to_file(APPLICATION_CSS_FILENAME, NAV_BAR_CSS)
  append_to_file(APPLICATION_HELPER_FILENAME, APPLICATION_HELPER)
end

generate_scaffolds
create_nav_bar
route "root to: 'pets#index'"
initialize_db
