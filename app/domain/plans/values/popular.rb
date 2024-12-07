# frozen_string_literal: true

module TrailSmith
  module Value
    # popular score
    class Popular
      HIGH_THRESHOLD = 1000
      LOW_THRESHOLD = 100
      def initialize(value)
        @value = value
      end

      def high?
        @value >= HIGH_THRESHOLD
      end

      def medium?
        @value > LOW_THRESHOLD && @value < HIGH_THRESHOLD
      end

      def low?
        @value <= LOW_THRESHOLD
      end
    end
  end
end
