require 'yaml'

CONSTANTS = HashWithIndifferentAccess.new(YAML.load_file(File.join(File.dirname(__FILE__), '..', 'constants.yml')))
