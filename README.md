# Templates for Rails

### Only tested on Rails 6.1.3.1, Linux/Ubuntu 20.04.2 LTS

#### NOTE: where used, `bundle add rexml` # needed for minitest on Linux


## Add Bootstap
- Use asset pipeline for CSS
- Use webpacker for javascript

### Steps to create new Rails app with Bootstrap 4 or 5
```
# HTTPS
git clone https://github.com/rlogwood/rails_templates.git

# SSH:
git clone git@github.com:rlogwood/rails_templates.git
```

### Configuration Prompts

Bootstrap v5 (@next) is the default version and you'll be ask to confirm:

    ***
    *** Default bootstrap is v5 @next (5.0.0-beta3)
    ***
    *** Use bootstrap v4 instead (N/y)?

If you're using Bootstrap v5, you'll have the option to load jQuery, which is needed for tooltips:

    ***
    *** Default bootstrap is v5 @next (5.0.0-beta3)
    ***
    *** Use bootstrap v4 instead (N/y)?
    ***
    *** You've chosen bootstrap 5, jQuery will only be loaded if you request it
    ***
    *** Do you want to add jQuery to bootstrap 5 (needed for tool tips) (N/y)?

### Environment Variables
You can set environment variables to avoid the prompts.

- To create a bootstrap v4 app without prompts:
    ```
    export USE_BOOTSTRAP_4=yes
    ```

- To create a bootstrap v5 with jQuery without prompts:
    ```
    export USE_BOOTSTRAP_5=yes
    export USE_QUERY=yes
    ```

### Create a bootstrap app
Add any other options needed. If you don't set environment variables you'll be prompted
```
rails new myapp -m rails_templates/add_bootstrap/template.rb
```
### Verify the result
Look for a message at the end of the output indicating the choices you made:

    ***
    *** Using Bootstrap v5 @next
    *** jQuery will be added
    ***


### Test that bootstrap works in your new app
```
cd myapp
bin/rails s
```

### Visit the Bootstrap Test page
- check the navbar drop-down, tool tip popups and modal to confirm everything works:
- visit [http://localhost:3000/bootstrap_test/index](http://localhost:3000/bootstrap_test/index)
