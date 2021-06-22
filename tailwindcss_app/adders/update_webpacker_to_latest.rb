# frozen_string_literal: true

def update_webpacker_to_latest_version
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
