# frozen_string_literal: true

# take a rails 6 app with production webpacker installed and upgrade it to the next version
def update_webpacker_to_vnext_version
  run "mv app/javascript/packs app/javascript/entrypoints"
  run "mv app/javascript app/packs"
  run "yarn remove webpack-dev-server"
  gsub_file 'Gemfile', /^gem 'webpacker',.*$/, "gem 'webpacker','#{Webpacker.config[:gemfile]}'"
  do_bundle
  run "yarn add #{Webpacker.config[:yarn_add]} --exact"
  run "bundle exec rails webpacker:install"
  run "rm .browserslistrc"
  copy_file('files/base.js', 'config/webpack/base.js', force: true)
  run "bin/webpack"
end

# the intent of this method was to create rails app with --skip-webpack-install
# and then manuall install the latest version, however, haven't found
# a successful way to do that
def install_latest_webpacker
  raise NotImplementedError, "implementation not supported"

  # these steps shouldn't be required for a new install
  # run "mv app/javascript/packs app/javascript/entrypoints"
  # run "mv app/javascript app/packs"
  # run "yarn remove webpack-dev-server"

  # skipping wepack install still seems to add the webpacker gem
  gsub_file 'Gemfile', /^gem 'webpacker',.*$/, "gem 'webpacker','#{Webpacker.config[:gemfile]}'"
  # this doesn't work if gem already present: gem('webpacker', Webpacker.config[:gemfile])
  do_bundle
  run "yarn add #{Webpacker.config[:yarn_add]} --exact"
  run "bundle exec rails webpacker:install"
  run "rm .browserslistrc"
  copy_file('files/base.js', 'config/webpack/base.js', force: true)
  run "bin/webpack"
end
