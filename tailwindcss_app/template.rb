
# Copied from: https://raw.githubusercontent.com/excid3/jumpstart/master/template.rb
# ==================================================================
# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("jumpstart-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/excid3/jumpstart.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{jumpstart/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) do
        git checkout: branch
      end
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

# TODO: research this, from Chris' RailsBytes for devise
def do_bundle
  # Custom bundle command ensures dependencies are correctly installed
  Bundler.with_unbundled_env { run "bundle install" }
end

# don't check in RubyMine project files
def update_gitignore
  append_to_file '.gitignore' do
    '.idea'
  end
end

def post_bundle_application_updates
  after_bundle do
    rails_command "webpacker:install:stimulus"
    add_devise
    add_cancancan
    add_navbar

    update_webpacker_to_vnext_version if WebpackerInstall.config[:using_vnext]
    add_tailwindcss
    update_babel_config_to_remove_warnings

    rails_command "db:drop"
    rails_command "db:create"
    rails_command "db:migrate"
    update_gitignore
  end
end

def require_template_adder_helpers
  # require every file in the adders directory
  Dir[File.join(__dir__, 'adders', '*.rb')].each { |file| require file }
end

add_template_repository_to_source_path
require_template_adder_helpers
post_bundle_application_updates
