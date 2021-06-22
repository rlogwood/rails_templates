# Templates for Rails

### Only tested on Rails 6.1.3.2, Linux/Ubuntu 20.04.2 LTS

### Cloning the repo
- HTTPS: `git clone https://github.com/rlogwood/rails_templates.git`
- SSH:   `git clone git@github.com:rlogwood/rails_templates.git`


### Available Templates 

<details>
  <summary>Create Tailwind CSS latest Template Instructions</summary>

## Create new Rails app with Tailwind CSS
   
   `rails new (my_app_name) -m rails_templates/tailwindcss_app/template.rb -d postgresql --skip-sprockets < rails_templates/tailwindcss_app/input.txt`

</details>

<details>
  <summary>Create Bootstrap 4 or 5 Template Instructions</summary>

## Create new Rails app with Bootstap
- Use asset pipeline for CSS
- Use webpacker for javascript

### Steps to create new Rails app with Bootstrap 4 or 5


### Configuration Prompts

Bootstrap v5 (@next) is the default version and you'll be asked to confirm:
```
    *** Default bootstrap is v5 @next (5.0.0-beta3)
    ***
    *** Use bootstrap v4 instead (N/y)?
```

If you're using Bootstrap v5, you'll have the option to load jQuery:
```
    *** You've chosen bootstrap 5, jQuery will only be loaded if you request it
    ***
    *** Do you want to add jQuery to bootstrap 5 (N/y)?
```

### Environment Variables
You can set environment variables to avoid the prompts.

- To create a bootstrap v4 app:
    ```
    export BOOTSTRAP_VERSION=4
    ```

- To create a bootstrap v5 app:
    ```
    export BOOTSTRAP_VERSION=5
    ```
- For Bootstrap 4,  jQuery is a requirement and automatically added

- For Bootstrap 5,  jQuery may be optionally added:
    ```
    export USE_QUERY=yes  # adds jQuery
    export USE_QUERY=no   # v5 app created without jQuery, no prompts 
    ```


### Run the template to create a bootstrap app
Add any other options needed. If you don't set environment variables you'll be prompted

```
rails new myapp -m rails_templates/add_bootstrap/template.rb
```

### Verify the result
Look for a message at the end of the output indicating the choices you made:
```
 *** Using Bootstrap v5 @next
 *** jQuery is not needed
 ```

### Test that bootstrap works in your new app
```
cd myapp
bin/rails s
```

### Visit the Bootstrap Test page
- check the navbar drop-down, tool tip popups and modal to confirm everything works:
- visit [http://localhost:3000/bootstrap_test/index](http://localhost:3000/bootstrap_test/index)

#### NOTE: where used, `bundle add rexml` # needed for minitest on Linux

</details>
