# frozen_string_literal: true

require_relative '../entities/wish'

module TrailSmith
  module Mapper
    # Maps API response to Wish entity
    class OpenaiMapper
      def self.build_entity(api_response)
        TrailSmith::Entity::Wish.new(api_response)
      end
    end
  end
end
