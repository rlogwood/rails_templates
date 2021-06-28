# frozen_string_literal: true


def add_tailwindcss
  add_tailwind_modules
  update_babel_config_to_remove_warnings
  create_homepage_with_tailwindcss_test
  run "npx tailwindcss init"
  # TODO: not sure if there is a thor command to do a rename, copy doesn't work because of the directory context
  run 'mv tailwind.config.js  default_tailwind.config.js'
  copy_file('files/tailwind.config.js', 'tailwind.config.js', force: true)
  configure_tailwindcss_application_stylesheet
  run 'mv postcss.config.js  default_postcss.config.js'
  copy_file(WebpackerInstall.postcss_config_source_filename, 'postcss.config.js', force: true)
end

private

# modules needed for the special postcss7 compatible build of tailwind
# this is the set modules to be used with webpacker v5
# see https://tailwindcss.com/docs/installation
def tailwind_postcss7_compat_modules
  %w[
    tailwindcss@npm:@tailwindcss/postcss7-compat
    postcss@^7 autoprefixer@^9
    @tailwindcss/typography @tailwindcss/forms
  ]
end

# modules needed for the most recent version of tailwind
# NOTE: tailwind latest is the default for webpacker v6
# TODO: determine if these are needed: postcss-import postcss-flexbugs-fixes postcss-preset-env?
def tailwind_latest_modules
  %w[
    tailwindcss@latest postcss@latest autoprefixer@latest
    css-loader mini-css-extract-plugin css-minimizer-webpack-plugin
    postcss-loader
    postcss-import postcss-flexbugs-fixes postcss-preset-env
    sass sass-loader
    @tailwindcss/typography @tailwindcss/forms
  ]
end

# use a specific set of modules for tailwind css that works with webpacker v6
# NOTE: While the current stable version is 2.2.2, this should be upgraded periodically
# to a newer stable version. tailwind 2.2.3 was broken and tailwind 2.2.4 was released
# the same day and worked (6/23/21). This "working" option for a stable
# setup of modules known to work ok with webpacker v6 and is useful for situations
# when @latest is broken.
def tailwind_working_set_of_modules
  %w[
    tailwindcss@2.2.2 postcss@8.3.5 autoprefixer@10.2.6
    css-loader@5.2.6 mini-css-extract-plugin@1.6.0 css-minimizer-webpack-plugin@3.0.1
    postcss-loader@6.1.0
    postcss-import postcss-flexbugs-fixes postcss-preset-env
    sass sass-loader
    @tailwindcss/typography@0.4.1 @tailwindcss/forms@0.3.3
  ]
end

def tailwind_modules_to_use
  if WebpackerInstall.config[:using_vnext]
    WebpackerInstall.config[:use_tailwind_latest] ? tailwind_latest_modules : tailwind_working_set_of_modules
  else
    tailwind_postcss7_compat_modules
  end
end

def add_tailwind_modules
  puts "\n***\n*** Adding Tailwind CSS Modules\n***"
  run "yarn add #{tailwind_modules_to_use.join(' ')}"
end

# generate some default pages for testing that includes a tailwind css test
# these pages are used in the example responsive navigation included in the
# application layout app/views/layout/application.html.erb
def create_homepage_with_tailwindcss_test
  generate 'controller', "pages home about services"
  copy_file('files/_tailwind_test.html.erb', 'app/views/shared/_tailwind_test.html.erb')
  append_to_file 'app/views/pages/home.html.erb', tailwind_test
  route "root to: 'pages#home'"
end

# provide a tailwind css test div to make sure things are working
def tailwind_test
  <<-END_STRING
    <%= render partial: 'shared/tailwind_test' %>
  END_STRING
end

# finalize setup for webpack stylesheet, note that css is used instead of scss
# TODO: figure out if scss is cmpatible with the webpack pipeline when using postcss
def configure_tailwindcss_application_stylesheet
  copy_file(WebpackerInstall.stylesheet_source_filename, WebpackerInstall.stylesheet_destination_filename)

  # the application css needs to be imported AFAIK, not sure why it can't automatically be picked up?!
  append_to_file "#{WebpackerInstall.config[:js_entrypoint]}/application.js" do
    <<~END_STRING
      import './#{WebpackerInstall.config[:stylesheet_name]}'
    END_STRING
  end

  # add a recommended font and make it the default
  inject_into_file 'app/views/layouts/application.html.erb', after: '<%= csp_meta_tag %>' do
    <<-'END_STRING'

    <link rel="stylesheet" href="https://rsms.me/inter/inter.css">
    END_STRING
  end

  # comment out the asset pipeline stylesheet tag
  gsub_file 'app/views/layouts/application.html.erb', '<%= stylesheet_link_tag ', '<%# stylesheet_link_tag '

  # add the webpack stylesheet tag
  inject_into_file 'app/views/layouts/application.html.erb', before: '    <%= javascript_pack_tag' do
    <<-END_STRING
    <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    END_STRING
  end
end
