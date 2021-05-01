# Provides the content modifications for the following files using heredocs:
#  1. app/assets/stylesheets/application.scss
#  2. config/webpack/environment.js
#  3. app/javascript/packs/application.js
#
# NOTES:
#  Bootstrap 4 includes jQuery
#  Bootstrap 5 doesn't doesn't include jQuery by default but you can request it for tooltips

module BootstrapMods
  extend self

  def application_scss
    <<~CODE
      @import 'bootstrap/scss/bootstrap'
    CODE
  end

  def webpack_environment_js
    <<~CODE

      const webpack = require('webpack')

      environment.plugins.append('Provide',
        new webpack.ProvidePlugin({
             #{webpack_plugins_jquery if BootstrapConfig.use_jquery?}
             Popper: ['popper.js', 'default']
        })
      )

    CODE
  end

  def application_js_additions
    <<~CODE

      // import the bootstrap javascript module
      import "bootstrap"
      #{"import {Tooltip, Popover} from 'bootstrap'" if BootstrapConfig.bootstrap_v5?}

      #{application_js_include_jquery if BootstrapConfig.use_jquery?}

      document.addEventListener("turbolinks:load",() => {
         #{BootstrapConfig.bootstrap_v5? ? turbo_links_load_bs5 : turbo_links_load_bs4}
      });

    CODE
  end

  private

  def webpack_plugins_jquery
    <<~CODE
      $: 'jquery',
      jQuery: 'jquery',
    CODE
  end

  def turbo_links_load_bs4
    <<~CODE
      $('[data-toggle="tooltip"]').tooltip()
      $('[data-toggle="popover"]').popover()
    CODE
  end

  def initialize_tool_tips
    <<~CODE
      function initialize_tooltips() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl)
        })
      }
    CODE
  end

  def turbo_links_load_bs5
    <<~CODE
      document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(element => new Tooltip(element))
      document.querySelectorAll('[data-bs-toggle="popover"]').forEach(element => new Popover(element))
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
