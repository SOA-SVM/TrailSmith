# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'spot'

module TrailSmith
  module Entity
    # Aggregate root for plans
    class Plan < Dry::Struct
      include Dry.Types

      attribute :id,         Integer.optional
      attribute :spots,      Strict::Array.of(Spot)
      attribute :travelling, Strict::Array.of(Travel)
      attribute :region,     Strict::String
      attribute :num_people, Strict::Integer
      attribute :day,        Strict::Integer

      def add_spot(spot_entity)
        spots << spot_entity
      end
    end
  end
end
