# frozen_string_literal: true

REPO_NAME = 'rails_templates'
TEMPLATE_DIR_NAME = 'nested_model_edit'
TEMPLATE_FILENAME = 'template.rb'
USERNAME = 'rlogwood'
REPO = "https://github.com/#{USERNAME}/#{REPO_NAME}.git"
BRANCH_NAME_REGEX = %r{#{REPO_NAME}/(.+)/#{TEMPLATE_DIR_NAME}/#{TEMPLATE_FILENAME}}

# make a clone of github repo
def clone_repo_into_temp_directory
  require "tmpdir"
  tempdir = Dir.mktmpdir(REPO_NAME)
  puts "*** tempdir: (#{tempdir})"

  at_exit { FileUtils.remove_entry(tempdir) }

  git clone: ["--quiet", REPO, tempdir].map(&:shellescape).join(" ")

  if (branch = __FILE__[BRANCH_NAME_REGEX, 1])
    Dir.chdir(tempdir) do
      git checkout: branch
    end
  end

  # template_dir
  File.join(tempdir,TEMPLATE_DIR_NAME)
end

# sourced originally from https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  template_dir =
    if __FILE__ =~ %r{\Ahttps?://}
      clone_repo
    else
      File.dirname(__FILE__)
    end

  source_paths.unshift(template_dir)
  puts "*** source_paths: (#{source_paths.join(" ")})"
  puts "*** template_dir: (#{template_dir})"
  template_dir
end

def generate_scaffold
  generate :model, 'step', 'order:integer', 'description', 'task:references'
  generate :model, 'task', 'summary', 'description:text', 'list:references'
  generate :model, 'list', 'name', 'board:references'
  generate :model, 'board', 'name', 'description'
  inject_into_class('app/models/task.rb',  'Task',   "  has_many :steps\n")
  inject_into_class('app/models/list.rb',  'List',   "  has_many :tasks\n")
  inject_into_class('app/models/board.rb', 'Board',  "  has_many :lists\n")
end

def install_files
  copy_file("files/db/seeds.rb", 'db/seeds.rb', force: true)
  copy_file('files/app/assets/stylesheets/pages.css', 'app/assets/stylesheets/pages.css')
  copy_file('files/app/controllers/pages_controller.rb', 'app/controllers/pages_controller.rb')
  directory('files/app/views/pages', 'app/views/pages')
end

def initialize_db
  rails_command "db:drop"

  # NOTE: as of 7/18/21 db:prepare behaves differently on SqlLite3 and PostgresSQL
  # explicitly running commands to avoid a seeding problem on SqlLite3
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end


add_template_repository_to_source_path
generate_scaffold
install_files
initialize_db
route "root to: 'pages#index'"

# Board:
#    List:
#       Task:
#          Step:
#          Step:
#          Step:
#       Task:
#          Step:
#          Step:
#    List:
#       Task:
#          Step:
#          Step:
#          Step:
#       Task:
#          Step:
#          Step: