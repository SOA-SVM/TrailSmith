# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'
require 'ostruct'

describe 'CreateLocation Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Create a location plan' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should create a new plan from valid input' do
      # GIVEN: valid OpenAI response with location data
      location_request = { 'query' => 'A 2-day trip for 4 people in Taipei' }

      # WHEN: request to create a location plan
      result = TrailSmith::Service::CreateLocation.new.call(location_request)

      # THEN: should create and return the plan
      _(result.success?).must_equal true
      plan = result.value!
      _(plan).must_be_kind_of TrailSmith::Entity::Plan
      _(plan.num_people).must_equal 4
      _(plan.region).must_equal 'Taipei'
      _(plan.day).must_equal 2
    end

    it 'SAD: should not create plan with invalid OpenAI response' do
      # GIVEN: invalid response format
      bad_query = { 'query' => 'invalid input that will cause OpenAI to fail' }

      # WHEN: request to create a location plan
      result = TrailSmith::Service::CreateLocation.new.call(bad_query)

      # THEN: should report error
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Could not get recommendations'
    end

    it 'BAD: should handle database error gracefully' do
      # GIVEN: database error occurs during creation
      DatabaseHelper.wipe_database
      location_request = { 'query' => 'A 2-day trip for 4 people in Taipei' }

      # WHEN: we try to create a plan but database fails
      TrailSmith::Repository::For.stub_any_instance(
        :create,
        proc { raise StandardError }
      )
      result = TrailSmith::Service::CreateLocation.new.call(location_request)

      # THEN: should report error
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Could not create location'
    end
  end
end