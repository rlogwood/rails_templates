# Templates for Rails

### Only tested on Rails 6.1.3.2, Linux/Ubuntu 20.04.2 LTS
- node v14.16.0
- yarn 1.22.10
- Rails 6.1.3.2
- ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]


### Cloning the repo
- HTTPS: `git clone https://github.com/rlogwood/rails_templates.git`
- SSH:   `git clone git@github.com:rlogwood/rails_templates.git`


### Available Templates 

<details>
  <summary>Create Tailwind CSS latest Template Instructions</summary>

## Create new Rails app with Tailwind CSS (latest version and PostCSS 8) 
This template lets you create a basic Rails 6 Tailwind CSS application with either:
- current production version of webpacker, which is v5 at this time
- next version of webpacker, which is currently 6.0.0.beta.7
- NOTE: using webpacker v5 will install  __TailWind PostCSS v7 compatibility version__
- NOTE: using webpacker next, 6.0.0.beta.7 will install  __TailWind v2.2.2 and PostCSS v8__
- NOTE: __Tailwind v2.2.3__ isn't currently supported

The template adds: stimulus js (used in responsive navbar), devise and cancancan.
To control these features, clone the repo and edit `tailwind_app/template.rb`.
It un-comments all lines in the devise db migration and adds a username and role. 
The template runs the migration at the end.

## Running the template:

There are 2 input files to answer the prompts to make creating the app easier. 
They default the devise model to `User` and add the additional fields, username and role.
You can make a copy and edit these files as needed or run the template and answer the prompts interactively.

#### Tailwind @Latest Webpacker v6
- Build Rails 6 Tailwind app with next version of webpacker 6.0.0.beta.7 and Tailwind @latest and PostCSS v8
- NOTE: Tailwind v2.2.2 can optionally be selected when running interactively
```
rails new (my_app_name) -m rails_templates/tailwindcss_app/template.rb -d postgresql --skip-sprockets < rails_templates/tailwindcss_app/input/webpacker_next_app.txt
```
#### Tailwind Compatible with PostCSS v7 Webpacker v5
- Build Rails 6 Tailwind app with production version of webpacker v5 and the Tailwind PostCss v7 compatible version
```
rails new (my_app_name) -m rails_templates/tailwindcss_app/template.rb -d postgresql --skip-sprockets < rails_templates/tailwindcss_app/input/webpacker_v5_app.txt
```
#### Run interactively to specify options
- Running the template and answering the prompts manually:
```
  rails new (my_app_name) -m rails_templates/tailwindcss_app/template.rb -d postgresql --skip-sprockets
```

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
