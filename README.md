# Templates for Rails

<details>
  <summary>Let's talk templates</summary>

### Tested on Rails 6, Linux/Ubuntu 20.04.2 LTS
- node v14.16.0
- yarn 1.22.10
- Rails 6.1.4
- ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]

### Cloning the repo
- HTTPS: `git clone https://github.com/rlogwood/rails_templates.git`
- SSH:   `git clone git@github.com:rlogwood/rails_templates.git`

### Overview

These templates create starter Rails apps. Currently there are 2 available:
1. Basic Bootstrap 4 or 5 application, using asset pipeline for the CSS and webpacker for javascript
- Bootstrap 5 is the default, Bootstrap 4 can be selected 
2. Basic Tailwind CSS application that provides a basic app with a few pages, devise authentication and a responsive navbar. 
- Tailwind CSS latest with PostCSS 8 is the default and achieved with using the next version of webpacker v6 beta 7.
- The PostCSS 7 version of tailwind can be selected
- This template supports installation directly from github

### Changes
The Rails, UI CSS frameworks and javascript libraries change frequently. Updates to any of these may
require that the templates in this repo be changed to stay current with the latest versions. 
If you notice a problem or that something is out of date, please contact me or make a pull request.

### Contributing
The Rails community benefits from having working, easy to use templates for creating a  
small working application to get a fast start in learning something new or creating a project.

There are a lot of options available. The templates in this repo are meant to address some of the more
fast moving parts of the eco system. Trying to find the right combination
of commands, gems and yarn packages to make things work, can be a time consuming exercise and
one where you'll find conflicting advice at times. A working rails template is like a fresh batch of 
well baked, warm cookies, they're tasty and ready to eat :) If you like the idea of providing the Rails
community fresh cookies, let's collaborate! :)

NOTE: These templates are a WIP and there have been no releases yet


#### As of 6/25/2021
1. Bootstrap 5 has been released and the latest production version will be installed
2. Tailwind CSS is released frequently, sometimes @latest maybe unstable. In those cases install the last tested stable version (currently 2.2.2, follow the prompts) 
3. Webpacker v6 and changes may require updates to this template 
</details>

### Available Templates 

<details> 
  <summary>Create Tailwind CSS Application Instructions</summary>

## Create new Rails app with Tailwind CSS (latest version and PostCSS 8) 
This template lets you create a basic Rails 6 Tailwind CSS application with either:
- current production version of webpacker, which is v5 at this time
- next version of webpacker, which is currently 6.0.0.beta.7
- NOTE: using webpacker v5 will install  __TailWind PostCSS v7 compatibility version and PostCSS v7 (`tailwindcss@npm:@tailwindcss/postcss7-compat`)__
- NOTE: using webpacker next, 6.0.0.beta.7 will install  __TailWind Latest (`tailwindcss@latest`) and PostCSS v8__
- NOTE: If you modify the input files or run interactively you can request a older stable version of Tailwind be installed, currently __Tailwind v2.2.2__.

The template adds: stimulus js (used in responsive navbar), devise and cancancan.
To control these features, clone the repo and edit `tailwind_app/template.rb`.
It un-comments all lines in the devise db migration and adds a username and role. 
The template runs the migration at the end.

## Running the template:

### 1. Run directly from github after retrieving the input file. 
- the example shown creates a tailwindcss@latest application with webpacker v6 
```
# Get the input file
wget https://raw.githubusercontent.com/rlogwood/rails_templates/main/tailwindcss_app/input/webpacker_next_app.txt

# Run the command from github redirecting input from the input file webpacker_nex_app.txt: 
rails new (my_app_name) -m https://raw.githubusercontent.com/rlogwood/rails_templates/main/tailwindcss_app/template.rb -d postgresql --skip-sprockets < webpacker_next_app.txt
```


### 2. Clone the repo and run the `rails new` specifying the path to the template files shown.
- There are 2 input files to answer the prompts to make creating the app easier. 
- They default the devise model to `User` and add the additional fields, username and role.
- You can make a copy and edit these files as needed or run the template and answer the prompts interactively.

### The following examples show how to run the template after it's been cloned:

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
  <summary>Create Bootstrap 5 or 4 Application Instructions</summary>

## Create a fresh Rails app with bootstrap and a test page
- follow the prompts, bootstrap 5 is the default
- avoid the prompts by reading how to setup environment variables with the answers below
- after starting the new app visit the bootstrap test page [http://localhost:3000/bootstrap_test/index](http://localhost:3000/bootstrap_test/index)
- NOTE: example command assumes you've cloned the repo to `~/myrepos` change as needed
- jQuery is optional with Bootstrap 5
- configures jQuery and popperjs correctly when installed
```
rails new myapp -m ~/myrepos/rails_templates/add_bootstrap/template.rb
```

## Create new Rails app with Bootstap
- Use asset pipeline for CSS
- Use webpacker for javascript

### Steps to create new Rails app with Bootstrap 4 or 5


### Configuration Prompts

Bootstrap v5 is the default version and you'll be asked to confirm:
```
    *** Default bootstrap is v5 
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
 *** Using Bootstrap v5
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
