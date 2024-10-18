#  frozen_string_literal: true

require 'http'

module TrailSmith
  module CloudTranslation
    # Gateway of Cloud Translation API
    class Api
      def initialize(token)
        @ct_token = token
      end

      def translations_data(source_texts, target_language)
        Request.new(@ct_token).get(source_texts, target_language).parse
      end

      # send out HTTP request to Google Cloud Translation
      class Request
        API_PATH = 'https://translation.googleapis.com/language/translate/v2'

        def initialize(token)
          @ct_token = token
        end

        def get(source, target = 'zh-TW')
          http_response = HTTP.post(API_PATH, params: { q: source, target:, key: @ct_token })

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        # BadRequest is raised when the API returns a 400 Bad Request response.
        BadRequest = Class.new(StandardError)
        Forbidden = Class.new(StandardError)

        HTTP_ERROR = {
          400 => BadRequest,
          403 => Forbidden
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
