
require 'fileutils'
require_relative 'bootstrap/bootstrap_config'
require_relative 'bootstrap/bootstrap_mods'
require_relative 'bootstrap/bootstrap_test'

def template_updates
  #  use scss in asset pipeline
  run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss'

  if BootstrapConfig.bootstrap_v5?
    run 'yarn add bootstrap@next @popperjs/core'
    if BootstrapConfig.use_jquery?
      run 'yarn add jquery'
    end
  else
    puts 'Using Bootstrap v4'
    run 'yarn add bootstrap jquery popper.js'
  end

  gem 'rexml' # needed for testing on Ubuntu

  append_to_file 'app/javascript/packs/application.js' do
    BootstrapMods.application_js_additions
  end

  append_to_file 'app/assets/stylesheets/application.scss' do
    BootstrapMods.application_scss
  end

  #file 'app/assets/stylesheets/application.scss', BootstrapMods.application_scss
end

say(BootstrapConfig.bootstrap_choice_description)

template_updates

after_bundle do
  #run 'rm config/webpack/environment.js'
  #file 'config/webpack/environment.js', BootstrapMods.webpack_environment_js

  inject_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')\n" do
   BootstrapMods.webpack_environment_js
  end

  rails_command 'webpacker:compile'
  run 'spring stop'
  generate(:controller, 'bootstrap_test', 'index')
  run 'rm -fr app/views/bootstrap_test'
  file 'app/views/bootstrap_test/index.html.erb', BootstrapTest.bootstrap_test
  say(BootstrapConfig.bootstrap_choice_description)
end
