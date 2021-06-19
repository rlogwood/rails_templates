def add_navbar
  #create_example_navigation_partial
  copy_file 'files/_navigation.html.erb' 'app/views/shared'
  copy_file 'files/navigation_controller.js' 'app/javascript/controller'
  #create_navigation_stimulus_controller
  gsub_file 'app/views/layouts/application.html.erb', '<%= yield %>', add_navigation_to_layout
end

private

def add_navigation_to_layout
  <<~'END_STRING'
    <%= render partial: 'shared/navigation' %>
    <div class="container mx-auto px-4">
    <%= yield %>
    </div>
  END_STRING
end

def create_example_navigation_partial
  create_file 'app/views/shared/_navigation.html.erb' do
    <<~'END_STRING'
      <nav data-controller="navigation" class="flex items-center justify-between flex-wrap bg-teal-500 p-6">
        <div class="flex items-center flex-shrink-0 text-white mr-6">
          <svg class="fill-current h-8 w-8 mr-2" width="54" height="54" viewBox="0 0 54 54" xmlns="http://www.w3.org/2000/svg"><path d="M13.5 22.1c1.8-7.2 6.3-10.8 13.5-10.8 10.8 0 12.15 8.1 17.55 9.45 3.6.9 6.75-.45 9.45-4.05-1.8 7.2-6.3 10.8-13.5 10.8-10.8 0-12.15-8.1-17.55-9.45-3.6-.9-6.75.45-9.45 4.05zM0 38.3c1.8-7.2 6.3-10.8 13.5-10.8 10.8 0 12.15 8.1 17.55 9.45 3.6.9 6.75-.45 9.45-4.05-1.8 7.2-6.3 10.8-13.5 10.8-10.8 0-12.15-8.1-17.55-9.45-3.6-.9-6.75.45-9.45 4.05z"/></svg>
          <span class="font-semibold text-xl tracking-tight">Tailwind CSS</span>
        </div>
        <div class="block md:hidden">
          <button data-action="navigation#toggle" class="flex items-center px-3 py-2 border rounded text-teal-200 border-teal-400 hover:text-white hover:border-white">
            <svg class="fill-current h-3 w-3" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><title>Menu</title><path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z"/></svg>
          </button>
        </div>
        <div data-navigation-target="menu" class="w-full hidden md:block flex-grow md:flex md:items-center md:w-auto">
          <div class="text-sm md:flex-grow">
            <a href="#responsive-header" class="nav-link">
              Docs
            </a>
            <a href="#responsive-header" class="nav-link">
              Examples
            </a>
            <a href="#responsive-header" class="nav-link">
              Blog
            </a>
          </div>
          <div class="text-sm md:flex-grow">
            <% if user_signed_in? %>
              <% if defined?(edit_user_registration_path) %>
                <%= link_to "Account", edit_user_registration_path, class: "nav-link" %>
              <% end %>

              <%= link_to "Logout", destroy_user_session_path, method: :delete, class: "nav-link" %>

            <% else %>
              <% if defined?(new_user_registration_path) %>
                <%= link_to "Sign Up", new_user_registration_path, class: "nav-link" %>
              <% end %>
              <%= link_to "Login", new_user_session_path, class: "nav-link" %>
            <% end %>
          </div>

        </div>
      </nav>
    END_STRING
  end
end

def create_navigation_stimulus_controller
  create_file 'app/javascript/controllers/navigation_controller.js' do
    <<~'END_STRING'
      import { Controller } from "stimulus"

      /* Note: the click action on a link href causes a new request and reinitialization of the controller
       * therefore it looks like data-action="navigation#hide" *is not needed* on these elements
       */

      export default class extends Controller {
          static targets = [ "menu" ]

          initialize() {
              this.showingMenu = false
          }

          connect() {
              console.log("navigation controller started!")
          }

          show() {
              console.log("showing menu")
              this.menuTarget.classList.remove("hidden")
              this.showingMenu = true
          }

          hide() {
              console.log("showing menu")
              this.menuTarget.classList.add("hidden")
              this.showingMenu = false
          }

          toggle() {
              this.showingMenu ? this.hide() : this.show()
          }

      }
    END_STRING
  end
end
