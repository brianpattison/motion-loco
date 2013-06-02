unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require 'awesome_print_motion'
require 'motion-require'
require 'motion-support/inflector'

Motion::Require.all(Dir.glob(File.expand_path('../motion-loco/**/*.rb', __FILE__)))