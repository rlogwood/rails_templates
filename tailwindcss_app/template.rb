# require every file in the adders directory
Dir[File.join(__dir__, 'adders', '*.rb')].each { |file| require file }

# TODO: research this, from Chris' RailsBytes for devise
def do_bundle
  # Custom bundle command ensures dependencies are correctly installed
  Bundler.with_unbundled_env { run "bundle install" }
end

# don't check in RubyMine project files
def update_gitignore
  append_to_file '.gitignore' do
    '.idea'
  end
end

def post_bundle_application_updates
  after_bundle do
    rails_command "webpacker:install:stimulus"
    add_devise
    add_cancancan
    add_navbar

    update_webpacker_to_vnext_version if WebpackerInstall.config[:using_vnext]
    add_tailwindcss
    update_babel_config_to_remove_warnings

    rails_command "db:drop"
    rails_command "db:create"
    rails_command "db:migrate"
    update_gitignore
  end
end

def source_paths
  [__dir__]
end

post_bundle_application_updates
