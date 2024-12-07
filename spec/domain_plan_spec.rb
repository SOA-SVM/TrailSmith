# frozen_string_literal: true

require_relative 'helpers/spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Maps API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_map
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Store spot' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save spot from Maps to database' do
      gpt_json = {
        num_people: 2,
        spots: %w[nthu nycu],
        region: 'Hsinchu',
        day: 3
      }

      plan = TrailSmith::GoogleMaps::PlanMapper.new(GOOGLE_MAPS_KEY, TEXT_QUERY_LIST, TYPE).build_entity

      _(plan[:spots][0].place_id).must_equal MAP_CORRECT['id']
      _(plan[:spots][0].formatted_address).must_equal MAP_CORRECT['formatted_address']
      _(plan[:spots][0].display_name).must_equal MAP_CORRECT['display_name']
      _(plan[:spots][0].rating).must_equal MAP_CORRECT['rating']
      _(plan[:spots][0].reviews).must_equal MAP_CORRECT['reviews']
    end
  end
end
