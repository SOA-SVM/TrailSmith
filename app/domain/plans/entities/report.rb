# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module TrailSmith
  module Entity
    # Domain entity for travel spots
    class Report < Dry::Struct
      include Dry.Types

      attribute :publish_time,      Strict::String
      attribute :rating,            Strict::Float
      attribute :text,              Strict::String

      def keywords
        # GPT keywords from the review text
        prompt = '1. The keyword with one or two words that could most describe the characteristic
                     of the spot for the tourist.
                  2. Do not give me a description of why choosing the keyword.'
        question = "Review:#{text} Prompt:#{prompt}"
        response = TrailSmith::OpenaiAPI.new(OPENAI_TOKEN).generate_text(question)
        response.messages.first['content']
      end

      def fun
        # fun score = (review rating + GPT rating) / 2
        prompt = '1. Rate how fun the spot is according to the text.
                  2. The maximum is 5 and the minimum is 0.
                  3. Just give the score'
        question = "Review:#{text} Prompt:#{prompt}"
        response = TrailSmith::OpenaiAPI.new(OPENAI_TOKEN).generate_text(question)
        value = (response.messages.first['content'].to_f + rating) / 2
        Value::Fun.new(value)
      end
    end
  end
end
