# frozen_string_literal: true

# take a rails 6 app with production webpacker installed and upgrade it to the next version
def update_webpacker_to_vnext_version
  run "mv app/javascript/packs app/javascript/entrypoints"
  run "mv app/javascript app/packs"
  run "yarn remove webpack-dev-server"
  gsub_file 'Gemfile', /^gem 'webpacker',.*$/, "gem 'webpacker','#{WebpackerInstall.config[:gemfile]}'"
  do_bundle
  run "yarn add #{WebpackerInstall.config[:yarn_add]} --exact"
  run "bundle exec rails webpacker:install"
  update_package_json
  run "yarn install"
  run "rm .browserslistrc"
  copy_file('files/base.js', 'config/webpack/base.js', force: true)
  run "bin/webpack"
end

private

def update_package_json
  update_webpack_and_webpack_cli_versions
  # specify a version of yarn and node that is known to work on Heroku heroku/nodejs build pack
  inject_into_file('package.json', after: '  "private": true,') { package_json_engines }
end

def update_webpack_and_webpack_cli_versions
  # Use the versions of webpack and webpack-cli that webpacker.6.0.0.beta.7 installs
  gsub_file 'package.json', /"webpack":.*$/, '"webpack": "^5.40.0",'
  gsub_file 'package.json', /"webpack-cli":.*$/, '"webpack-cli": "^4.7.2"'
end

def package_json_engines
  <<-STRING_END

    "engines": {
      "yarn": "1.22.10",
      "node": "14.16"
    },
  STRING_END
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
  gsub_file 'Gemfile', /^gem 'webpacker',.*$/, "gem 'webpacker','#{WebpackerInstall.config[:gemfile]}'"
  # this doesn't work if gem already present: gem('webpacker', WebpackerInstall.config[:gemfile])
  do_bundle
  run "yarn add #{WebpackerInstall.config[:yarn_add]} --exact"
  run "bundle exec rails webpacker:install"
  run "rm .browserslistrc"
  copy_file('files/base.js', 'config/webpack/base.js', force: true)
  run "bin/webpack"
end
