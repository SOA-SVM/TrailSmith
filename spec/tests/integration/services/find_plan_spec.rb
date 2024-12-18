# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'
require 'ostruct'

describe 'FindPlan Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Find a plan' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return a plan that exists' do
      # GIVEN: a valid plan exists locally
      new_plan = TrailSmith::GoogleMaps::PlanMapper
        .new(GOOGLE_MAPS_KEY)
        .build_entity(GPT_JSON)
      stored_plan = TrailSmith::Repository::For.entity(new_plan)
        .create(new_plan)

      # WHEN: we request to find the plan
      result = TrailSmith::Service::FindPlan.new.call(stored_plan.id)

      # THEN: we should get back the plan
      _(result.success?).must_equal true
      plan = result.value!
      _(plan.id).must_equal stored_plan.id
      _(plan.region).must_equal stored_plan.region
      _(plan.day).must_equal stored_plan.day
    end

    it 'SAD: should not find a plan that does not exist' do
      # GIVEN: we try to find a non-existent plan
      non_existent_id = -1

      # WHEN: we request to find the plan
      result = TrailSmith::Service::FindPlan.new.call(non_existent_id)

      # THEN: it should return a failure
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Could not find the plan.'
    end

    it 'BAD: should handle database error gracefully' do
      # GIVEN: database has some error
      DatabaseHelper.wipe_database

      # WHEN: we try to find a plan with an invalid id
      result = TrailSmith::Service::FindPlan.new.call('invalid_id')

      # THEN: it should return a failure
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Could not access database'
    end
  end
end