# frozen_string_literal: true

# Create a standard devise install with everything enabled
# Add additional attributes username:string and role:string
# NOTE: initial source https://railsbytes.com/public/templates/X8Bsjx
def add_devise
  run "bundle add devise"
  do_bundle

  rails_command "generate devise:install"

  model_name = ask("What do you want to call your Devise model?")
  attributes = ""
  if yes?("Do you want to any extra attributes to #{model_name}? [y/n]")
    attributes = ask("What attributes?")
  end

  # We don't use rails_command here to avoid accidentally having RAILS_ENV=development as an attribute
  run "rails generate devise #{model_name} #{attributes}"

  rails_command "generate devise:views"

  update_devise_db_migration
end

private

def update_devise_db_migration
  devise_migration_filename = Dir.glob('db/migrate/*_devise_create_users.rb').first
  gsub_file devise_migration_filename, '# t.', 't.'
  gsub_file devise_migration_filename, '# add_index :', 'add_index :'
end
