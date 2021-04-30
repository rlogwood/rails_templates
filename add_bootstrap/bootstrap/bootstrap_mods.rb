# provides the content for the following files using heredocs:
# 1. app/assets/stylesheets/application.scss
# 2. config/webpack/environment.js
# 3. app/javascript/packs/application.js
module BootstrapMods
  extend self

  # public methods

  # Make bootstrap 5 @next the default version
  # set USE_BOOTSTRAP_4 in the environment to use version 4
  def use_bootstrap_v5_next
    !ENV.key?('USE_BOOTSTRAP_4')
    #$use_bootstrap_5
  end

  def bootstrap_version_name
    use_bootstrap_v5_next ? "v(5/next)" : "v4"
  end

  def use_jquery
    !use_bootstrap_v5_next
  end

  # @import '../../../node_modules/bootstrap/scss/bootstrap';
  def application_scss_v1
    _application_scss_v1
  end

  # uses @import 'bootstrap'
  def application_scss_v2
    _application_scss_v2
  end

  alias application_scss application_scss_v1

  def webpack_environment_js
    <<~CODE
      const { environment } = require('@rails/webpacker')
      const webpack = require('webpack')

      environment.plugins.append('Provide',
        new webpack.ProvidePlugin({
             #{_webpack_plugins_jquery if use_jquery}
             Popper: ['popper.js', 'default']
        })
      )

      module.exports = environment
    CODE
  end

  def application_js
    <<~CODE
      // This file is automatically compiled by Webpack, along with any other files
      // present in this directory. You're encouraged to place your actual application logic in
      // a relevant structure within app/javascript and only use these pack files to reference
      // that code so it'll be compiled.
      import Rails from "@rails/ujs"
      import Turbolinks from "turbolinks"
      import * as ActiveStorage from "@rails/activestorage"
      import "channels"

      Rails.start()
      Turbolinks.start()
      ActiveStorage.start()

      // import the bootstrap javascript module
      import "bootstrap"

      #{_application_js_include_jquery if use_jquery}

      document.addEventListener("tubolinks:load",() => {
         #{use_bootstrap_v5_next ? _turbo_links_load_bs5 : _turbo_links_load_bs4}
      });
    CODE
  end

  # private methods
  # NOTE: methods starting with '_' are private

  # NOTE: Bootstrap 4 includes jQuery
  # NOTE: Bootstrap 5 doesn't doesn't include jQuery
  # NOTE: Template does not currently support adding jQuery for Bootstrap v5,
  # if you need jQuery use Bootstrap 4
  def _webpack_plugins_jquery
    <<~CODE
             $: 'jquery',
             jQuery: 'jquery',
    CODE
  end

  def _turbo_links_load_bs4
    <<~CODE
      $('[data-toggle="tooltip"]').tooltip()
      $('[data-toggle="popover"]').popover()
    CODE
  end

  def _turbo_links_load_bs5
    <<~CODE
      $('[data-bs-toggle="tooltip"]').tooltip()
      $('[data-bs-toggle="popover"]').popover()
    CODE
  end

  def _application_js_include_jquery
    <<~CODE
      var jQuery = require('jquery')

      // include jQuery in global and window scope (so you can access it globally)
      // in your web browser, when you type $('.div'), it is actually refering to global.$('.div')
      global.$ = global.jQuery = jQuery;
      window.$ = window.jQuery = jQuery;
    CODE
  end

  def _application_scss_v1
    <<~CODE
      /*
       * This is a manifest file that'll be compiled into application.css, which will include all the files
       * listed below.
       *
       * Any CSS and SCSS file within this directory, lib/assets/stylesheets, or any plugin's
       * vendor/assets/stylesheets directory can be referenced here using a relative path.
       *
       * You're free to add application-wide styles to this file and they'll appear at the bottom of the
       * compiled file so the styles you add here take precedence over styles defined in any other CSS/SCSS
       * files in this directory. Styles in this file should be added after the last require_* statement.
       * It is generally better to create a new file per style scope.
       *
       *= require_tree .
       *= require_self
       */

       @import 'bootstrap/scss/bootstrap'
       /*@import '../../../node_modules/bootstrap/scss/bootstrap';*/
    CODE
  end

  def _application_scss_v2
    <<~CODE
      // $navbar-default-bg: #312312;
      // $light-orange: #ff8c00;
      // $navbar-default-color: $light-orange;

      #
      @import 'bootstrap/scss/bootstrap'
    CODE
  end
end
