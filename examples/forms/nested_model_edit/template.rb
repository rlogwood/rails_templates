# frozen_string_literal: true

# Creates an example nested model for testing nested forms
#
# Board: [0..N]
#    List: [0..N]
#       Task: [0..N]
#          Step: [0..N]
#
# uses ActionView Form helper fields_for and ActiveRecord helper accepts_nested_attributes_for

BOARD_CLASS_INJECTION = <<-'RUBY'
  has_many :lists
  accepts_nested_attributes_for :lists, allow_destroy: true, reject_if: :all_blank
RUBY

LIST_CLASS_INJECTION = <<-'RUBY'
  has_many :tasks
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: :all_blank
RUBY

TASK_CLASS_INJECTION = <<-'RUBY'
  has_many :steps
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
RUBY

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
  inject_into_class('app/models/task.rb',  'Task', TASK_CLASS_INJECTION)
  inject_into_class('app/models/list.rb',  'List', LIST_CLASS_INJECTION)
  inject_into_class('app/models/board.rb', 'Board', BOARD_CLASS_INJECTION)
end

def install_files
  copy_file("files/db/seeds.rb", 'db/seeds.rb', force: true)
  copy_file('files/app/assets/stylesheets/boards.css', 'app/assets/stylesheets/boards.css')
  copy_file('files/app/controllers/boards_controller.rb', 'app/controllers/boards_controller.rb')
  directory('files/app/views/boards', 'app/views/boards')
  copy_file('files/config/routes.rb', 'config/routes.rb', force: true)
end

def initialize_db
  rails_command "db:drop"

  # NOTE: as of 7/18/21 db:prepare behaves differently on SqlLite3 and PostgresSQL
  # explicitly running commands to avoid a seeding problem on SqlLite3
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"
end

def install_gems
  gem_group :development do
    gem 'pry-byebug'
    gem 'better_errors'
  end
end


add_template_repository_to_source_path
generate_scaffold
install_files
install_gems
initialize_db


