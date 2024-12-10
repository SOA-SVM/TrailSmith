# frozen_string_literal: true

module TrailSmith
  module Entity
    # Utility functions for Wish
    module WishUtils
      def self.extract_messages(content)
        content.fetch('choices', []).map { |choice| choice['message'] }
      end

      def self.valid_content?(content)
        content.is_a?(Hash) && content.key?('choices')
      end
    end

    # Represents a processed response from OpenAI API
    class Wish
      attr_reader :messages

      def initialize(content = {})
        @messages = WishUtils.extract_messages(content)
        raise "Invalid data: #{content.inspect}" unless WishUtils.valid_content?(content)
      end
    end
  end
end
