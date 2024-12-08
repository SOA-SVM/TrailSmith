# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../require_app'
require_app

GOOGLE_MAPS_KEY = TrailSmith::App.config.GOOGLE_MAPS_KEY

TEXT_QUERY = 'NTHU'
TYPE = 'RELAX'
STARTING_SPOT = 'ChIJB7ZNzXI2aDQREwR22ltdKxE'
NEXT_SPOT = 'ChIJBXLgwuk1aDQRuu4aKYS0jF4'
TRAVEL_MODE = 'walking'
GPT_JSON = '{
  "num_people": 2,
  "spots": ["nthu", "nycu"],
  "region": "Hsinchu",
  "day": 3
}'

MAP_CORRECT = YAML.safe_load_file('spec/fixtures/maps_results.yml', permitted_classes: [Symbol])
DISTANCE_CORRECT = YAML.safe_load_file('spec/fixtures/distance_api_results.yml')
