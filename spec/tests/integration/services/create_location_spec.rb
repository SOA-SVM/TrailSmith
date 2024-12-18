# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'CreateLocation Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_location
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Create a location plan' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should create a new plan from valid input' do
      # GIVEN: valid query input
      validate_input = { query: 'I want a day trip to Taipei' }

      # WHEN: request to create a location plan
      result = TrailSmith::Service::CreateLocation.new.call(validate_input)

      # THEN: should create and return the plan
      _(result.success?).must_equal true

      if result.success?
        plan = result.value!
        _(plan).must_be_kind_of TrailSmith::Entity::Plan
        _(plan.region).must_equal 'Taipei'
        _(plan.spots).wont_be_empty
      end
    end

    it 'SAD: should not create plan with invalid input' do
      # GIVEN: invalid input
      bad_query = { query: nil }

      # WHEN: request to create a location plan
      result = TrailSmith::Service::CreateLocation.new.call(bad_query)

      # THEN: should report error
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Invalid input: query is missing'
    end

    it 'SAD: should not create plan with empty query' do
      # GIVEN: empty query
      empty_query = { query: '' }

      # WHEN: request to create a location plan
      result = TrailSmith::Service::CreateLocation.new.call(empty_query)

      # THEN: should report error
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Invalid input: query is missing'
    end
  end
end
