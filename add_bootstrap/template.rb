require 'fileutils'
require 'shellwords'
require_relative 'bootstrap/bootstrap_mods'
require_relative 'bootstrap/bootstrap_test'

if BootstrapMods.use_bootstrap_v5_next
  puts "Using Bootstrap v5 @next"
  puts "** NOT LOADING jQuery **"
else
  puts "Using Bootstrap v4"
end


def template_updates
  # remove all files replaced by this template
  run 'rm app/javascript/packs/application.js'
  run 'rm app/assets/stylesheets/application.css'
  if BootstrapMods.use_bootstrap_v5_next
    run 'yarn add bootstrap@next @popperjs/core'
  else
    puts 'Using Bootstrap v4'
    run 'yarn add bootstrap jquery popper.js'
  end

  gem 'rexml' # needed for testing on Ubuntu
  file 'app/javascript/packs/application.js', BootstrapMods.application_js
  file 'app/assets/stylesheets/application.scss', BootstrapMods.application_scss
end

template_updates

after_bundle do
  run 'rm config/webpack/environment.js'
  file 'config/webpack/environment.js', BootstrapMods.webpack_environment_js
  rails_command 'webpacker:compile'
  run 'spring stop'
  generate(:controller, 'bootstrap_test', 'index')
  run 'rm -fr app/views/bootstrap_test'
  file 'app/views/bootstrap_test/index.html.erb', BootstrapTest.bootstrap_test
end
