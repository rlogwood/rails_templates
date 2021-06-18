def add_tailwindcss
  add_tailwind_modules
  update_babel_config
  update_postcss_config
  create_homepage_with_tailwindcss_test
  configure_tailwindcss_application_scss
  run "npx tailwindcss init"
end

private

def update_gitignore
  append_to_file '.gitignore' do
    '.idea'
  end
end


def add_tailwind_modules
  tailwindcss_modules = %w[
    tailwindcss@npm:@tailwindcss/postcss7-compat
    postcss@^7 autoprefixer@^9
    @tailwindcss/typography @tailwindcss/forms
  ]

  run "yarn add #{tailwindcss_modules.join(' ')}"
end

def update_babel_config
  inject_into_file 'babel.config.js', after: '    plugins: [' do
    <<-RUBY

      ["@babel/plugin-proposal-private-methods", { "loose": true }],
    RUBY
  end

end

def update_postcss_config
  inject_into_file 'postcss.config.js', after: '})' do
    <<~RUBY
      ,
          require('tailwindcss'),
          require('autoprefixer'),
          require('@tailwindcss/typography')
    RUBY
  end

end

def create_homepage_with_tailwindcss_test
  generate 'controller', "pages home about"

  append_to_file 'app/views/pages/home.html.erb' do
    <<~RUBY
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
    RUBY
  end

  route "root to: 'pages#home'"
end


def configure_tailwindcss_application_scss
  create_file 'app/javascript/packs/application.scss' do
    <<~'RUBY'
      @import "tailwindcss/base";
      @import "tailwindcss/components";
      @import "tailwindcss/utilities";
    RUBY
  end

  append_to_file 'app/javascript/packs/application.js' do
    <<~'RUBY'
      import './application.scss'
    RUBY
  end

  gsub_file 'app/views/layouts/application.html.erb', '<%= stylesheet_link_tag ', '<%# stylesheet_link_tag '

  inject_into_file 'app/views/layouts/application.html.erb', before: '    <%= javascript_pack_tag' do
    <<-'RUBY'
    <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    RUBY
  end
end
