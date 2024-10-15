#  frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module TrailSmith
  module Entity
    # Domain entity for any sentences
    class Sentence < Dry::Struct
      include Dry.Types

      attribute :translated_text, Strict::Array.of(String)
      attribute :source_language, Strict::Array.of(String)
    end
  end
end
