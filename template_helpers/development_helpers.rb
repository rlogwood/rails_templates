module TemplateHelpers
  module DevelopmentHelpers
    extend self

    def install_development_gems
      gem_group :development do
        gem 'pry-byebug'
        gem 'better_errors'
        gem 'binding_of_caller'
      end
    end

    # don't check-in
    # .idea - RubyMine project files
    # *~ - emacs backupt files
    def update_gitignore
      append_to_file '.gitignore' do
        '.idea'
        '*~'
      end
    end

    def perform_initial_commit
      git add: "."
      git commit: %Q{ -m 'Initial commit' }
    end
  end
end
