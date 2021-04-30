# Templates for Rails

### Only tested on Rails 6.1.3.1, Linux/Ubuntu 20.04.2 LTS

#### NOTE: where used, `bundle add rexml` # needed for minitest on Linux


## Add Bootstap

### Steps to create new Rails app with Bootstrap 4 or 5
```
# HTTPS
git clone https://github.com/rlogwood/rails_templates.git

# SSH:
git clone git@github.com:rlogwood/rails_templates.git
```

### Create bootstrap v5 app, the default
```
# add any other options needed
rails new myapp -m rails_templates/add_bootstrap/template.rb
```

### Create bootstrap v4 app, set USE_BOOTSTRAP_4
```
export USE_BOOTSTRAP_4=anything
rails new myapp -m rails_templates/add_bootstrap/template.rb
```

### Test that bootstrap works in your new app
```
cd myapp
bin/rails db:create
bin/rails s
```

### Visit the Bootstrap Test page
- check the navbar drop-down, tool tip popups and modal to confirm everything works:
[http://localhost:3000/bootstrap_test/index](http://localhost:3000/bootstrap_test/index)
