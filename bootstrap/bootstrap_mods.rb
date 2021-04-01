module BootstrapMods
  def self.webpack_environment_js
    <<-CODE
    const { environment } = require('@rails/webpacker')

    const webpack = require('webpack')

    environment.plugins.append('Provide',
        new webpack.ProvidePlugin({
               Popper: ['popper.js', 'default']
        })
    )

    module.exports = environment
    CODE
  end

  def self.application_js
    <<-CODE
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

      document.addEventListener("tubolinks:load",() => {
          $('[data-toggle="tooltip"]').tooltip()
          $('[data-toogle="popover"]').popover()
      });
    CODE
  end

  def self.application_scss
    <<-CODE
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

      @import '../../../node_modules/bootstrap/scss/bootstrap';
    CODE
  end

  def self.bootstrap_test
    <<-CODE
      end
      <div class="container">
      <h1>h1. Bootstrap heading</h1>
      <h2>h2. Bootstrap heading</h2>
      <h3>h3. Bootstrap heading</h3>
      <h4>h4. Bootstrap heading</h4>
      <h5>h5. Bootstrap heading</h5>
      <h6>h6. Bootstrap heading</h6>

      <h3>
        Fancy display heading
        <small class="text-muted">With faded secondary text</small>
      </h3>

      <h1 class="display-1">Display 1</h1>
      <h1 class="display-2">Display 2</h1>
      <h1 class="display-3">Display 3</h1>
      <h1 class="display-4">Display 4</h1>
      <h1 class="display-5">Display 5</h1>
      <h1 class="display-6">Display 6</h1>

      <p>You can use the mark tag to <mark>highlight</mark> text.</p>
      <p><del>This line of text is meant to be treated as deleted text.</del></p>
      <p><s>This line of text is meant to be treated as no longer accurate.</s></p>
      <p><ins>This line of text is meant to be treated as an addition to the document.</ins></p>
      <p><u>This line of text will render as underlined.</u></p>
      <p><small>This line of text is meant to be treated as fine print.</small></p>
      <p><strong>This line rendered as bold text.</strong></p>
      <p><em>This line rendered as italicized text.</em></p>

      <figure>
        <blockquote class="blockquote">
          <p>A well-known quote, contained in a blockquote element.</p>
        </blockquote>
        <figcaption class="blockquote-footer">
          Someone famous in <cite title="Source Title">Source Title</cite>
        </figcaption>
      </figure>

      <button type="button" class="btn btn-primary">Primary</button>
      <button type="button" class="btn btn-secondary">Secondary</button>
      <button type="button" class="btn btn-success">Success</button>
      <button type="button" class="btn btn-danger">Danger</button>
      <button type="button" class="btn btn-warning">Warning</button>
      <button type="button" class="btn btn-info">Info</button>
      <button type="button" class="btn btn-light">Light</button>
      <button type="button" class="btn btn-dark">Dark</button>

      <button type="button" class="btn btn-link">Link</button>

      <button type="button" class="btn btn-outline-primary">Primary</button>
      <button type="button" class="btn btn-outline-secondary">Secondary</button>
      <button type="button" class="btn btn-outline-success">Success</button>
      <button type="button" class="btn btn-outline-danger">Danger</button>
      <button type="button" class="btn btn-outline-warning">Warning</button>
      <button type="button" class="btn btn-outline-info">Info</button>
      <button type="button" class="btn btn-outline-light">Light</button>
      <button type="button" class="btn btn-outline-dark">Dark</button>

      <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">Navbar</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
              <li class="nav-item">
                <a class="nav-link active" aria-current="page" href="#">Home</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Link</a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                  Dropdown
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                  <li><a class="dropdown-item" href="#">Action</a></li>
                  <li><a class="dropdown-item" href="#">Another action</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="#">Something else here</a></li>
                </ul>
              </li>
              <li class="nav-item">
                <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
              </li>
            </ul>
            <form class="d-flex">
              <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
              <button class="btn btn-outline-success" type="submit">Search</button>
            </form>
          </div>
        </div>
      </nav>
      </div>
    CODE
  end
end
