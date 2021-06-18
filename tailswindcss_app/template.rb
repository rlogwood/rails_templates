require_relative 'adders/add_tailwindcss'
require_relative 'adders/add_devise'
require_relative 'adders/add_cancancan'

after_bundle do
  rails_command "db:drop"
  rails_command "db:create"
  add_tailwindcss
  rails_command "webpacker:install:stimulus"
  add_devise
  add_cancancan
end

