# frozen_string_literal: false

require 'json'
require_relative 'spot_mapper'

module TrailSmith
  module GoogleMaps
    # build plan entity
    class PlanMapper
      def initialize(key)
        @key = key
      end

      def build_entity(gpt_json)
        gpt_json = JSON.parse(gpt_json)
        TrailSmith::Entity::Plan.new(
          id: nil,
          spots: gpt_json['spots'].map do |spot_query|
            SpotMapper.new(@key).build_entity(spot_query)
          end,
          # travelling: ,
          region: gpt_json['region'],
          num_people: gpt_json['num_people'],
          day: gpt_json['day']
        )
      end
    end
  end
end
