# frozen_string_literal: false

require 'json'
require_relative 'spot_mapper'
require_relative 'way_mapper'

module TrailSmith
  module GoogleMaps
    # build plan entity
    class PlanMapper
      def initialize(key)
        @key = key
      end

      def build_entity(gpt_json)
        gpt_dict = JSON.parse(gpt_json)
        TrailSmith::Entity::Plan.new(
          id: nil,
          spots: build_spot_array(gpt_dict['spots']),
          travelling: build_way_array(spots, gpt_dict['travel_mode']),
          region: gpt_dict['region'],
          num_people: gpt_dict['num_people'],
          day: gpt_dict['day']
        )
      end

      def build_spot_array(name_array)
        name_array.map do |name|
          SpotMapper.new(@key).build_entity(name)
        end
      end

      def build_way_array(spot_array, travel_mode_array)
        (0..travel_mode_array.length).map do |i|
          Distance::WayMapper.new(@key).find(spot_array[i].place_id, spot_array[i + 1].place_id, travel_mode[i])
        end
      end
    end
  end
end
