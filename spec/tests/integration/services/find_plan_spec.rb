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

    it 'HAPPY: should find a plan that is being watched' do
      # GIVEN: a valid plan exists locally and is being watched
      new_plan = TrailSmith::GoogleMaps::PlanMapper
        .new(GOOGLE_MAPS_KEY)
        .build_entity(GPT_JSON)
      stored_plan = TrailSmith::Repository::For.entity(new_plan)
        .create(new_plan)

      input = {
        requested: stored_plan.id,
        watched_list: [stored_plan.id]
      }

      # WHEN: we request to find this plan
      result = TrailSmith::Service::FindPlan.new.call(input)

      # THEN: we should get back the plan
      _(result.success?).must_equal true
      found = result.value![:plan]
      _(found.id).must_equal stored_plan.id
    end

    it 'SAD: should not find plans that are not being watched' do
      # GIVEN: a plan exists but is not in watched list
      new_plan = TrailSmith::GoogleMaps::PlanMapper
        .new(GOOGLE_MAPS_KEY)
        .build_entity(GPT_JSON)
      stored_plan = TrailSmith::Repository::For.entity(new_plan)
        .create(new_plan)

      input = {
        requested: stored_plan.id,
        watched_list: [] # empty watched list
      }

      # WHEN: we request to find this plan
      result = TrailSmith::Service::FindPlan.new.call(input)

      # THEN: it should return an error
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Please first request this plan to be added to your list'
    end

    it 'SAD: should not find non-existent plans' do
      # GIVEN: request for non-existent plan
      input = {
        requested: -1,
        watched_list: [-1]
      }

      # WHEN: we request to find this plan
      result = TrailSmith::Service::FindPlan.new.call(input)

      # THEN: it should return a not found error
      _(result.success?).must_equal false
      _(result.failure).must_equal 'Plan not found'
    end
  end
end