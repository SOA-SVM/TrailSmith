# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'ListPlan Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Proxy connect' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return the JavaScript response for valid API token' do
      # GIVEN: a valid API token
      valid_token = GOOGLE_MAPS_KEY

      # WHEN: we request for the proxy service
      result = TrailSmith::Service::GoogleMapsProxy.new.call(valid_token)

      # THEN: it should return successful response
      _(result.success?).must_equal true
      response = result.value!
      _(response).must_include 'initMap'
    end
  end
end
