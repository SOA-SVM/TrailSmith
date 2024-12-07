# frozen_string_literal: true

require 'http'

module TrailSmith
  module GoogleMaps
    # Library for Github Web API
    class Api
      def initialize(key)
        @key = key
      end

      def place_data(text_query)
        Request.new(@key).text_search(text_query).parse['places'][0]
      end

      # Sends out HTTP requests to Github
      class Request
        def initialize(key)
          @key = key
        end

        def text_search(text_query)
          url = 'https://places.googleapis.com/v1/places:searchText'
          place_info = 'places.id,places.displayName'
          report_info = 'places.rating,places.reviews,places.userRatingCount'
          http_response = HTTP.headers(
            'X-Goog-Api-Key'   => @key,
            'X-Goog-FieldMask' => "#{place_info},#{report_info}"
          ).post(url, json: { textQuery: text_query })

          Response.new(http_response).tap do |response|
            raise response.error unless response.successful?
          end
        end
      end

      # Decorates HTTP responses
      class Response < SimpleDelegator
        BadRequest = Class.new(StandardError)
        Forbidden = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          400 => BadRequest,
          403 => Forbidden,
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end

# require 'json'
# GOOGLE_MAPS_KEY = 'test'
# TEXT_QUERY = 'NTHU'
# test = TrailSmith::GoogleMaps::Api.new(GOOGLE_MAPS_KEY).place_data(TEXT_QUERY)
