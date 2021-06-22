# frozen_string_literal: true


def add_tailwindcss
  add_tailwind_modules
  update_babel_config_to_remove_warnings
  create_homepage_with_tailwindcss_test
  run "npx tailwindcss init"
  # TODO: not sure if there is a thor command to do a rename, copy doesn't work because of the directory context
  run 'mv tailwind.config.js  default_tailwind.config.js'
  copy_file('files/tailwind.config.js', 'tailwind.config.js', force: true)
  copy_file('files/application.css', "#{Webpacker.config[:js_entrypoint]}/application.css")
  run 'mv postcss.config.js  default_postcss.config.js'
  copy_file('files/postcss.config.js', 'postcss.config.js', force: true)
  configure_tailwindcss_application_scss
end

private



def update_gitignore
  append_to_file '.gitignore' do
    '.idea'
  end
end


# TODO: for postcss v8, found this list somewhere in postcss.config.js
# Review which moudules are needed for postcss v8
#     postcss-import
#     postcss-flexbugs-fixes
#     postcss-preset-env
#  Add the postcss 7 compatible tailwind configuration
#  see https://tailwindcss.com/docs/installation
def add_tailwind_postcss7_compat_modules
  tailwindcss_modules = %w[
    tailwindcss@npm:@tailwindcss/postcss7-compat
    postcss@^7 autoprefixer@^9
    @tailwindcss/typography @tailwindcss/forms
  ]

  run "yarn add -D #{tailwindcss_modules.join(' ')}"
end

# TODO: are these needed: postcss-flexbugs-fixes postcss-preset-env
def add_tailwind_latest_modules
  tailwindcss_modules = %w[
    tailwindcss@latest postcss@latest autoprefixer@latest
    css-loader mini-css-extract-plugin css-minimizer-webpack-plugin
    postcss-loader
    @tailwindcss/typography @tailwindcss/forms
  ]

  run "yarn add -D #{tailwindcss_modules.join(' ')}"
end

def add_tailwind_modules
  #add_tailwind_postcss7_compat_modules
  add_tailwind_latest_modules
end

# Add suggested fix to remove Babel config compilation warnings
# This warning appears without this fix:
# The "loose" option must be the same for @babel/plugin-proposal-class-properties,
#      @babel/plugin-proposal-private-methods and @babel/plugin-proposal-private-property-in-object
#      (when they are enabled): you can silence this warning by explicitly adding
# 	["@babel/plugin-proposal-private-methods", { "loose": true }]
# to the "plugins" section of your Babel config.
# Though the "loose" option was set to "false" in your @babel/preset-env config,
# it will not be used for @babel/plugin-proposal-private-methods since the
# "loose" mode option was set to "true" for @babel/plugin-proposal-class-properties.
def update_babel_config_to_remove_warnings
  inject_into_file 'babel.config.js', after: '    plugins: [' do
    <<-END_STRING

      ["@babel/plugin-proposal-private-methods", { "loose": true }],
    END_STRING
  end
end

def create_homepage_with_tailwindcss_test
  generate 'controller', "pages home about services"
  copy_file('files/_tailwind_test.html.erb', 'app/views/shared/_tailwind_test.html.erb')
  append_to_file 'app/views/pages/home.html.erb', tailwind_test
  route "root to: 'pages#home'"
end

def tailwind_test
  <<-END_STRING
    <%= render partial: 'shared/tailwind_test' %>
  END_STRING
end

def configure_tailwindcss_application_scss
  append_to_file "#{Webpacker.config[:js_entrypoint]}/application.js" do
    <<~END_STRING
      import './application.css'
    END_STRING
  end

  inject_into_file 'app/views/layouts/application.html.erb', after: '<%= csp_meta_tag %>' do
    <<-'END_STRING'

    <link rel="stylesheet" href="https://rsms.me/inter/inter.css">
    END_STRING
  end

  gsub_file 'app/views/layouts/application.html.erb', '<%= stylesheet_link_tag ', '<%# stylesheet_link_tag '

  inject_into_file 'app/views/layouts/application.html.erb', before: '    <%= javascript_pack_tag' do
    <<-END_STRING
    <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    END_STRING
  end
end
