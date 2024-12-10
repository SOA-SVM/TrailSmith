# frozen_string_literal: true

require 'http'
# require 'yaml'
# require_relative 'wish'
# require 'irb'
# require 'json'

module TrailSmith
  module  Openai
    # Library for OpenAI API
    class OpenaiAPI
      def initialize(token)
        @token = token
      end

      def generate_text(prompt, model = 'gpt-4o-mini', max_tokens: 50)
        api_response = Request.new(@token).get(prompt, model, max_tokens).parse
        TrailSmith::Mapper::OpenaiMapper.build_entity(api_response)
      end

      class Request
        API_PATH = 'https://api.openai.com/v1/chat/completions'

        def initialize(token)
          @token = token
        end

        def get(prompt, model = 'gpt-4o-mini', max_tokens = 50)
          http_response = HTTP.headers(build_headers).post(API_PATH, json: build_body(prompt, model, max_tokens))
          TrailSmith::Openai::OpenaiAPI::Response.new(http_response).validate
        end

        private

        def build_headers
          {
            'Content-Type'  => 'application/json',
            'Authorization' => "Bearer #{@token}"
          }
        end

        def build_body(prompt, model, max_tokens)
          {
            model: model,
            messages: [{ role: 'user', content: prompt }],
            max_tokens: max_tokens
          }
        end
      end

      class Response < SimpleDelegator
        BadRequest = Class.new(StandardError)
        Unauthorized = Class.new(StandardError)
        RateLimitExceeded = Class.new(StandardError)

        HTTP_ERROR = { 400 => BadRequest, 401 => Unauthorized, 429 => RateLimitExceeded }.freeze

        def successful?
          !HTTP_ERROR.key?(code)
        end

        def error
          HTTP_ERROR[code]&.new("HTTP Error #{code}: #{body}") || StandardError.new("Unexpected error: #{body}")
        end

        def parse
          JSON.parse(body.to_s)
        end

        def parse_content
          parse['choices'].first['message']['content']
        end

        # Validates the response, raising an error if it is not successful
        def validate
          raise error unless successful?

          self
        end

        # Safely validates the response, returning a boolean instead of raising an error
        def svalidate_safely
          successful?
        end
      end
    end
  end
end
