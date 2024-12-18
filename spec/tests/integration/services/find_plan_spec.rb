# frozen_string_literal: true

require_relative '../../../helpers/spec_helper_openai'
require 'irb'

describe 'Integration test of FindPlan service' do
  let(:plan_id) { 1 }

  it 'must find a specific plan when the ID exists' do
    # GIVEN the plan exists in database
    stored_plan = TrailSmith::Entity::Plan.new(
      id: 1,
      num_people: 4,
      region: 'Taipei',
      day: 2,
      spots: [],
      routes: []
    )
    TrailSmith::Repository::For.stub_any_instance(
      :find_id,
      stored_plan
    )

    # WHEN we request to find the plan
    result = TrailSmith::Service::FindPlan.new.call(plan_id)

    # THEN we should receive a successful result with the plan
    _(result.success?).must_equal true
    plan = result.value!
    _(plan).must_be_kind_of TrailSmith::Entity::Plan
    _(plan.id).must_equal 1
    _(plan.region).must_equal 'Taipei'
  end

  it 'must fail when trying to find a non-existent plan' do
    # GIVEN the plan does not exist in database
    TrailSmith::Repository::For.stub_any_instance(
      :find_id,
      nil
    )

    # WHEN we request to find the plan
    result = TrailSmith::Service::FindPlan.new.call(plan_id)

    # THEN we should receive a failure result
    _(result.success?).must_equal false
    _(result.failure).must_equal 'Could not find the plan.'
  end

  it 'must fail gracefully when database error occurs' do
    # GIVEN database access fails
    TrailSmith::Repository::For.stub_any_instance(
      :find_id,
      proc { raise StandardError }
    )

    # WHEN we request to find the plan
    result = TrailSmith::Service::FindPlan.new.call(plan_id)

    # THEN we should receive a failure result
    _(result.success?).must_equal false
    _(result.failure).must_equal 'Could not access database'
  end
end

