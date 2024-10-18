#  frozen_string_literal: true

module TrailSmith
  module CloudTranslation
    # Data Mapper: translations -> sentence entity
    class SentenceMapper
      def initialize(token, gateway_class = CloudTranslation::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(source_texts, target_language)
        data = @gateway.translations_data(source_texts, target_language)
        SentenceMapper.build_entity(data)
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          TrailSmith::Entity::Sentence.new(
            translated_text:,
            source_language:
          )
        end

        def translated_text
          @data['data']['translations'].map { |arr| arr['translatedText'] }
        end

        def source_language
          @data['data']['translations'].map { |arr| arr['detectedSourceLanguage'] }
        end
      end
    end
  end
end
