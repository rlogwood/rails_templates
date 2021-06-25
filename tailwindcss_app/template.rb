

def clone_repo
  require "tmpdir"
  tempdir = Dir.mktmpdir("rails_templates-")
  puts "*** tempdir: (#{tempdir})"

  # TODO: add back at_exit when debugging done
  # at_exit { FileUtils.remove_entry(tempdir) }
  git clone: [
    "--quiet",
    "https://github.com/rlogwood/rails_templates.git",
    tempdir
  ].map(&:shellescape).join(" ")

  if (branch = __FILE__[%r{rails_templates/(.+)/tailwindcss_app/template.rb}, 1])
    Dir.chdir(tempdir) do
      git checkout: branch
    end
  end

  # template_dir
  File.join(tempdir,"tailwindcss_app")
end


# Copied from: https://raw.githubusercontent.com/excid3/jumpstart/master/template.rb
# which it copied it from: https://github.com/mattbrictson/rails-template
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

# require_template_adder_helpers(template_dir)
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

def post_bundle_application_updates(template_dir)
  Dir[File.join(template_dir, 'adders', '*.rb')].each do |filename|
    puts "*** requiring file: #{filename}"
    require filename
  end
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

def require_template_adder_helpers(template_dir)
  # require every file in the adders directory
  Dir[File.join(template_dir, 'adders', '*.rb')].each { |file| require file }
end

template_dir = add_template_repository_to_source_path
post_bundle_application_updates(template_dir)
