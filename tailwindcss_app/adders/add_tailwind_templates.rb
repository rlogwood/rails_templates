def copy_scaffold_templates(template_dir)
  copy_template_files(template_dir)
  copy_template_stylesheets(template_dir)
  copy_error_message_partial(template_dir)
end

private

def copy_template_files(template_dir)
  # add tailwind scaffolding templates
  source_dir = File.join(template_dir,'files', 'lib', 'templates')
  destination_dir = File.join('lib','templates')
  # NOTE: Thor directory command tries to evaluate templates (files ending in .tt)
  # so we hae to have our own copy command
  copy_dir(source_dir, destination_dir)
end

def copy_dir(source_dir, destination_dir)
  run "rm -fr #{destination_dir}"
  run "mkdir  -p #{destination_dir}"
  copy_target_dir = File.join(destination_dir,"..")
  run "cp -pfR #{source_dir} #{copy_target_dir}"
end

def copy_template_stylesheets(template_dir)
  source_dir = File.join(template_dir,'files', 'stylesheets', 'components')
  dest_dir = File.join('app', 'packs', 'stylesheets', 'components')
  run "rm -fr #{dest_dir}"
  directory source_dir, dest_dir
end

def copy_devise_views(template_dir)
  source_dir = File.join(template_dir,'files', 'views', 'devise')
  dest_dir = File.join('app', 'views', 'devise')
  run "rm -fr #{dest_dir}"
  directory source_dir, dest_dir
end
