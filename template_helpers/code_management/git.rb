# frozen_string_literal: true

# basic functionality that may be used in in more than one template
module TemplateHelpers
  # updates for default .gitignore
  module Git
    extend self

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