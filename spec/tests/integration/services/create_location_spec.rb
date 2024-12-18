# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of CreateLocation service with OpenAI and Google Maps' do
  let(:input_query) { 'A 1-day trip for 2 people in Taipei' }
  let(:openai_response) do
    {
      'num_people' => 2,
      'region' => 'Taipei',
      'day' => 1,
      'spots' => [
        { 'name' => 'Taipei 101', 'location' => 'Some location data' }
      ],
      'mode' => 'tourist'
    }.to_json
  end

  it 'must create a new location plan when given valid input' do
    # GIVEN OpenAI responds with a valid recommendation
    TrailSmith::Openai::OpenaiMapper.stub_any_instance(
      :build_prompt,
      OpenStruct.new(messages: [openai_response])
    )

    # WHEN we request to create a location plan
    params = { 'query' => input_query }
    result = TrailSmith::Service::CreateLocation.new.call(params)

    # THEN we should receive a successful result with a stored plan
    _(result.success?).must_equal true
    plan = result.value!
    _(plan).must_be_kind_of TrailSmith::Entity::Plan
    _(plan.num_people).must_equal 2
    _(plan.region).must_equal 'Taipei'
    _(plan.day).must_equal 1
  end

  it 'must fail gracefully when OpenAI fails to respond' do
    # GIVEN OpenAI fails to respond
    TrailSmith::Openai::OpenaiMapper.stub_any_instance(
      :build_prompt,
      nil
    )

    # WHEN we request to create a location plan
    params = { 'query' => input_query }
    result = TrailSmith::Service::CreateLocation.new.call(params)

    # THEN we should receive a failure result
    _(result.success?).must_equal false
    _(result.failure).must_equal 'Could not get recommendations'
  end

  it 'must fail gracefully when database operation fails' do
    # GIVEN OpenAI responds but database save fails
    TrailSmith::Openai::OpenaiMapper.stub_any_instance(
      :build_prompt,
      OpenStruct.new(messages: [openai_response])
    )
    TrailSmith::Repository::For.stub_any_instance(
      :create,
      proc { raise StandardError }
    )

    # WHEN we request to create a location plan
    params = { 'query' => input_query }
    result = TrailSmith::Service::CreateLocation.new.call(params)

    # THEN we should receive a failure result
    _(result.success?).must_equal false
    _(result.failure).must_equal 'Could not create location'
  end
end