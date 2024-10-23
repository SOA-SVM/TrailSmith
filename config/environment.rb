#  frozen_string_literal: true

require 'roda'
require 'yaml'

module TrailSmith
  class APP < Roda
    CONFIG = YAML.safe_load_file("config/secrets.yml")
    GOOGLE_MAPS_KEY = CONFIG['GOOGLE_MAPS_KEY']
  end
end