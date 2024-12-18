# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'tiredness'

module TrailSmith
  module Value
    # The travel route between two spots
    class Route < Dry::Struct
      include Dry.Types

      attribute :id,                Strict::Integer.optional
      attribute :starting_spot,     Strict::String
      attribute :next_spot,         Strict::String
      attribute :travel_mode,       Strict::String
      attribute :travel_time,       Strict::Integer
      attribute :travel_time_desc,  Strict::String
      attribute :distance,          Strict::Integer
      attribute :distance_desc,     Strict::String
      attribute :overview_polyline, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end

      TRAVEL_MODE_WEIGHTS = {
        'walking'   => 10,
        'bicycling' => 8,
        'transit'   => 6,
        'driving'   => 4
      }.freeze

      # Calculates the relaxing index based on travel mode, distance, and travel time
      def tiredness
        weight = TRAVEL_MODE_WEIGHTS.fetch(travel_mode, 3)

        # Adjust relaxing score based on distance and travel time
        score = (distance / 1000.0) + (travel_time / 60.0)
        Tiredness.new(weight * score)
      end
    end
  end
end
