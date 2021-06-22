# frozen_string_literal: true

def add_cancancan
  run "bundle add cancancan"
  do_bundle
  rails_command "generate cancan:ability"
end
