# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Google Maps API' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VCR.eject_cassette
  end

  describe 'Plan information' do
    it 'HAPPY: should provide correct spot attributes' do
      spot = TrailSmith::GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).build_entity(TEXT_QUERY)
      _(spot.place_id).must_equal MAP_CORRECT[:place_id]
      _(spot.name).must_equal MAP_CORRECT[:name]
      _(spot.rating).must_equal MAP_CORRECT[:rating]
      _(spot.rating_count).must_equal MAP_CORRECT[:rating_count]

      # check Reports Entity
      (0..4).each do |i|
        # check Report Entity
        _(spot.reports.report_array[i].publish_time).must_equal MAP_CORRECT[:reports][i][:publish_time]
        _(spot.reports.report_array[i].rating).must_equal MAP_CORRECT[:reports][i][:rating]
        _(spot.reports.report_array[i].text).must_equal MAP_CORRECT[:reports][i][:text]
      end
    end

    it 'HAPPY: should provide correct plan attributes' do
      plan = TrailSmith::GoogleMaps::PlanMapper.new(GOOGLE_MAPS_KEY).build_entity(GPT_JSON)
      # gpt_json's spots = ["nthu", "nycu"]
      _(plan.spots[0].place_id).must_equal MAP_CORRECT[:place_id]
      _(plan.spots[0].name).must_equal MAP_CORRECT[:name]
      _(plan.spots[0].rating).must_equal MAP_CORRECT[:rating]
      _(plan.spots[0].rating_count).must_equal MAP_CORRECT[:rating_count]

      # check Reports Entity
      (0..4).each do |i|
        # check Report Entity
        _(plan.spots[0].reports.report_array[i].publish_time).must_equal MAP_CORRECT[:reports][i][:publish_time]
        _(plan.spots[0].reports.report_array[i].rating).must_equal MAP_CORRECT[:reports][i][:rating]
        _(plan.spots[0].reports.report_array[i].text).must_equal MAP_CORRECT[:reports][i][:text]
      end
    end

    it 'BAD: SpotMapper should raise exception with wrong key' do
      _(proc do
        TrailSmith::GoogleMaps::SpotMapper.new('WRONG_KEY').build_entity(TEXT_QUERY)
      end).must_raise TrailSmith::GoogleMaps::Api::Response::BadRequest
    end

    it 'BAD: PlanMapper should raise exception with wrong key' do
      _(proc do
        TrailSmith::GoogleMaps::PlanMapper.new('WRONG_KEY').build_entity(GPT_JSON)
      end).must_raise TrailSmith::GoogleMaps::Api::Response::BadRequest
    end
  end
end
