# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'reports'

module TrailSmith
  module Entity
    # Domain entity for spots
    class Spot < Dry::Struct
      include Dry.Types

      attribute :id,           Integer.optional
      attribute :place_id,     Strict::String
      attribute :name,         Strict::String
      attribute :rating,       Strict::Float
      attribute :rating_count, Strict::Integer
      attribute :reports,      Strict::Reports

      def fun
        reports.fun
      end

      def popular
        rating_count
      end

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
