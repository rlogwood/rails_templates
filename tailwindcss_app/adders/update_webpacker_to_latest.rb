def update_webpacker_to_latest
  # v6.0.0-beta.7
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