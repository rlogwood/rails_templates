# frozen_string_literal: true

# basic functionality that may be used in in more than one template
module TemplateHelpers
  # encapsulate adding jQuery to a webpacker 5 application
  module JQueryWebpack5
    extend self

    def add_jquery
      run 'yarn add jquery'
      append_to_file 'app/javascript/packs/application.js', application_js_include_jquery
      #                 config/webpack/environment.js
      insert_into_file 'config/webpack/environment.js', after: "const { environment } = require('@rails/webpacker')\n" do
        webpack_environment_js
      end
    end

    private

    def webpack_environment_js
      <<~CODE

        const webpack = require('webpack')

        environment.plugins.append('Provide',
            new webpack.ProvidePlugin({
                #{webpack_plugins_jquery}
            })
        )

      CODE
    end

    def webpack_plugins_jquery
      <<~CODE
        $: 'jquery',
            jQuery: 'jquery',
      CODE
    end

    def application_js_include_jquery
      <<~CODE
        var jQuery = require('jquery')

        // include jQuery in global and window scope (so you can access it globally)
        // in your web browser, when you type $('.div'), it is actually refering to global.$('.div')
        global.$ = global.jQuery = jQuery;
        window.$ = window.jQuery = jQuery;
      CODE
    end
  end
end