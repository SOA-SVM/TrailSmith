# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require_relative 'report'

module TrailSmith
  module Entity
    # Domain entity for report
    class Reports < Dry::Struct
      include Dry.Types

      attribute :report_array, Strict::Array.of(Report)

      def keywords
        # array of keywords of reports
        report_array.flat_map(&:keywords).uniq
      end

      def fun
        # average fun score of reports
        report_array.map(&:fun).sum / report_array.length
      end
    end
  end
end
