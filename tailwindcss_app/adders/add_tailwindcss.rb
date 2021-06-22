# frozen_string_literal: true

def webpack_entrypoints
  #prod_webpack_entryponts = "app/javascript/packs"
  next_webpack_entryponts = "app/packs/entrypoints"
  #webpack_entryponts = next_webpack_entryponts
  next_webpack_entryponts
end

def add_tailwindcss
  add_tailwind_modules
  update_babel_config_to_remove_warnings
  #update_postcss_config
  create_homepage_with_tailwindcss_test
  run "npx tailwindcss init"
  # TODO: not sure if there is a thor command to do a rename, copy doesn't work because of the directory context
  run 'mv tailwind.config.js  default_tailwind.config.js'
  copy_file('files/tailwind.config.js', 'tailwind.config.js', force: true)
  copy_file('files/application.css', "#{webpack_entrypoints}/application.css")
  configure_tailwindcss_application_scss
  run 'mv postcss.config.js  default_postcss.config.js'
  copy_file('files/postcss.config.js', 'postcss.config.js', force: true)
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

# def update_postcss_config
#   inject_into_file 'postcss.config.js', after: '})' do
#     <<~END_STRING
#       ,
#           require('tailwindcss'),
#           require('autoprefixer')
#     END_STRING
#   end
# end

def create_homepage_with_tailwindcss_test
  generate 'controller', "pages home about"
  append_to_file 'app/views/pages/home.html.erb', tailwind_test_div
  route "root to: 'pages#home'"
end

def tailwind_test_div
  <<-END_STRING
    <div class="font-sans bg-white h-screen flex flex-col w-full">
      <div class="h-screen bg-gradient-to-r from-green-400 to-blue-500">
        <div class="px-4 py-48">
          <div class="relative w-full text-center">
            <h1
              class="animate-pulse font-bold text-gray-200 text-2xl mb-6">
              Your TailwindCSS setup is working if this pulses...
            </h1>
          </div>
        </div>
      </div>
    </div>
  END_STRING
end

def configure_tailwindcss_application_scss
  append_to_file "#{webpack_entrypoints}/application.js" do
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


=begin
def configure_tailwindcss_application_scss
  create_file 'app/javascript/packs/application.scss' do
    <<~END_STRING
      @import "tailwindcss/base";
      @import "tailwindcss/components";
      @import "tailwindcss/utilities";
    END_STRING
  end

=end