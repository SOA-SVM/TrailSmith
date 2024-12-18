# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  MAP_CASSETTE = 'maps_api'
  LOCATION_CASSETTE = 'location_api'

  def self.setup_vcr
    VCR.configure do |vcr_config|
      vcr_config.cassette_library_dir = CASSETTES_FOLDER
      vcr_config.hook_into :webmock
    end
  end

  def self.configure_vcr_for_map(recording: :new_episodes)
    VCR.configure do |vcr_config|
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY>') { GOOGLE_MAPS_KEY }
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY_ECS>') { CGI.escape(GOOGLE_MAPS_KEY) }
    end

    VCR.insert_cassette(
      MAP_CASSETTE,
      record: recording,
      match_requests_on: %i[method uri headers],
      allow_playback_repeats: true
    )
  end

  def self.configure_vcr_for_location(recording: :new_episodes)
    VCR.configure do |vcr_config|
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY>') { GOOGLE_MAPS_KEY }
      vcr_config.filter_sensitive_data('<GOOGLE_MAPS_KEY_ECS>') { CGI.escape(GOOGLE_MAPS_KEY) }
      vcr_config.filter_sensitive_data('<OPENAI_TOKEN>') { OPENAI_TOKEN }
      vcr_config.filter_sensitive_data('<OPENAI_TOKEN>') { CGI.escape(OPENAI_TOKEN) }
    end

    VCR.insert_cassette(
      LOCATION_CASSETTE, record: recording, match_requests_on: %i[method uri headers], allow_playback_repeats: true
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
