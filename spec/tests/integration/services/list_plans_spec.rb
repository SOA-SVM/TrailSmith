# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'ListPlan Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Add a plan' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return plans that are being watched' do
      # GIVEN: a valid plan exists locally and is being watched
      new_plan = TrailSmith::GoogleMaps::PlanMapper
        .new(GOOGLE_MAPS_KEY)
        .build_entity(GPT_JSON)
      TrailSmith::Repository::For.entity(new_plan)
        .create(new_plan)

      watched_list = []

      # WHEN: we request a list of all watched plans
      result = TrailSmith::Service::ListPlans.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      plans = result.value!
      _(plans).must_equal []
    end

    it 'SAD: should not watched plans if they are not loaded' do
      # GIVEN: we are watching a plan that does not exist locally
      watched_list = [-1]

      # WHEN: we request a list of all watched plans
      result = TrailSmith::Service::ListPlans.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      plans = result.value!
      _(plans).must_equal []
    end
  end
end
