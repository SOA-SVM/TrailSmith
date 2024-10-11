#  frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'translation'

module SVM
  # send out HTTP request to Google Cloud Translation
  class Request
    API_PATH = 'https://translation.googleapis.com/language/translate/v2'

    def initialize(token)
      @token = token
    end

    def get(source, target = 'zh-TW')
      http_response = HTTP.post(API_PATH, params: { q: source, target:, key: @token })

      Response.new(http_response).tap do |response|
        raise(response.error) unless response.successful?
      end
    end
  end

  # Decorates HTTP responses with success/error
  class Response < SimpleDelegator
    # BadRequest is raised when the API returns a 400 Bad Request response.
    BadRequest = Class.new(StandardError)

    HTTP_ERROR = { 400 => BadRequest }.freeze

    def successful?
      !HTTP_ERROR.keys.include?(code)
    end

    def error
      HTTP_ERROR[code]
    end
  end

  # Library for Google Cloud API
  class CloudApi
    def initialize(token)
      @token = token
    end

    def translation(source_texts, target_language)
      translation_response = Request.new(@token).get(source_texts, target_language).parse
      Translation.new(translation_response)
    end
  end
end
