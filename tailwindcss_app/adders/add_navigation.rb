# frozen_string_literal: true

def add_navbar
  copy_file('files/_navigation.html.erb', 'app/views/shared/_navigation.html.erb')

  navigation_controller_destination =
    File.join(WebpackerInstall.config[:js_entrypoint], '..', 'controllers', 'navigation_controller.js')

  copy_file('files/navigation_controller.js', navigation_controller_destination)
  gsub_file 'app/views/layouts/application.html.erb', '    <%= yield %>', add_navigation_to_layout
end

private

def add_navigation_to_layout
  <<-'END_STRING'
    <%= render partial: 'shared/navigation' %>
    <div class="container mx-auto px-4">
      <%= yield %>
    </div>
  END_STRING
end
