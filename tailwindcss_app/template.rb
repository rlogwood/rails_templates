require_relative 'utility/file_utils'
require_relative 'adders/add_tailwindcss'
require_relative 'adders/add_devise'
require_relative 'adders/add_cancancan'
require_relative 'adders/add_navigation'

def post_bundle_application_updates
  after_bundle do
    add_tailwindcss
    rails_command "webpacker:install:stimulus"
    add_devise
    add_cancancan
    add_navbar
    rails_command "db:drop"
    rails_command "db:create"
    rails_command "db:migrate"
  end
end

def source_paths
  [__dir__]
end


post_bundle_application_updates

