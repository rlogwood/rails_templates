# frozen_string_literal :true

def do_bundle
  # Custom bundle command ensures dependencies are correctly installed
  Bundler.with_unbundled_env { run "bundle install" }
end

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
