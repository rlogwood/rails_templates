def update_webpacker_to_latest_version
  webpacker_next_version = {}
  webpacker_next_version[:gemfile] = "6.0.0.beta.7"
  webpacker_next_version[:yarn] = "@rails/webpacker@6.0.0-beta.7"

  # gem 'webpacker', '~> 5.0'
  run "mv app/javascript/packs app/javascript/entrypoints"
  run "mv app/javascript app/packs"
  run "yarn remove webpack-dev-server"
  #gsub_file 'Gemfile', " *gem 'webpacker',.*", "gem 'webpacker', '#{webpacker_next_version[:gemfile]}'"
  #gsub_file 'Gemfile', /^gem 'webpacker',.*$/, "gem 'webpacker', '6.0.0.beta.7'"
  gsub_file 'Gemfile', /^gem 'webpacker',.*$/, "gem 'webpacker', '#{webpacker_next_version[:gemfile]}'"
  do_bundle
  run "yarn add #{webpacker_next_version[:yarn]} --exact"
  run "bundle exec rails webpacker:install"
  run "rm .browserslistrc"
  copy_file('files/base.js', 'config/webpack/base.js', force: true)
  run "bin/webpack"
end


# steps
# Richard Logwood  1 day ago
# ~/src/repos/webpacker$ git status
# HEAD detached at v6.0.0.beta.7
# nothing to commit, working tree clean
# cd ..
# rails new wptst -d postgresql
# cd wptst
# update Gemfile: gem 'webpacker', path: '../webpacker'
# update package.json: "@rails/webpacker": "file:../webpacker",
# reinstalled webpacker with: bundle exec rails webpacker:install
# removed .browserslistrc
# re-added local change to package.json: "@rails/webpacker": "file:../webpacker",
# shell1: bin/webpack-dev-server
# shell2: bin/rails s
# got the splash page