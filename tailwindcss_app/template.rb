require_relative 'adders/add_tailwindcss'
require_relative 'adders/add_devise'
require_relative 'adders/add_cancancan'
require_relative 'adders/add_navigation'
require_relative 'adders/update_webpacker_to_latest'

# TODO: research this, from Chris' RailsBytes for devise
def do_bundle
  # Custom bundle command ensures dependencies are correctly installed
  Bundler.with_unbundled_env { run "bundle install" }
end

def post_bundle_application_updates
  after_bundle do
    #add_tailwindcss
    rails_command "webpacker:install:stimulus"
    add_devise
    add_cancancan
    add_navbar
    update_webpacker_to_latest_version
    add_tailwindcss

    rails_command "db:drop"
    rails_command "db:create"
    rails_command "db:migrate"
  end
end

def source_paths
  [__dir__]
end


post_bundle_application_updates
