# frozen_string_literal: true

# Add suggested fix to remove Babel config compilation warnings
# This warning appears without this fix:
# The "loose" option must be the same for @babel/plugin-proposal-class-properties,
#      @babel/plugin-proposal-private-methods and @babel/plugin-proposal-private-property-in-object
#      (when they are enabled): you can silence this warning by explicitly adding
# 	["@babel/plugin-proposal-private-methods", { "loose": true }]
# to the "plugins" section of your Babel config.
# Though the "loose" option was set to "false" in your @babel/preset-env config,
# it will not be used for @babel/plugin-proposal-private-methods since the
# "loose" mode option was set to "true" for @babel/plugin-proposal-class-properties.
def update_babel_config_to_remove_warnings
  inject_into_file 'babel.config.js', after: '    plugins: [' do
    <<-END_STRING

      ["@babel/plugin-proposal-private-methods", { "loose": true }],
    END_STRING
  end
end
