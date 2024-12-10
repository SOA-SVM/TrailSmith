# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'report'
require_relative '../values/fun'
require_relative '../values/popular'

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
      attribute :reports,      Array.of(Report)

      def fun
        # average fun score of reports
        Value::Fun.new(reports.map(&:fun).sum / reports.length)
      end

      def popular
        Value::Fun.new(rating_count)
      end

      def to_attr_hash
        to_hash.except(:id)
      end

      def keywords
        # array of keywords of reports
        reports.flat_map(&:keywords).uniq
      end
    end
  end
end
