# frozen_string_literal: true

require_relative 'spec_helper_openai'
require_relative 'lib/gateways/openai_api'
require_relative 'lib/mappers/openai_mapper'
require_relative 'lib/entities/wish'
require 'irb'

describe 'Test OpenAI API liabrary' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<OPENAI_TOKEN>') { OPENAI_TOKEN }
    c.filter_sensitive_data('<OPENAI_TOKEN_ESC>') { CGI.escape(OPENAI_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'OpenAI Information' do
    it 'HAPPY: should provide a successful response from the API' do
      # binding.irb
      response = TrailSmith::Openai::OpenaiAPI.new(OPENAI_TOKEN).generate_text(QUESTION)
      # binding.irb
      _(response.messages.first['content']).must_include EXPECTED_RESPONSE
    end

    it 'SAD: should gracefully handle an invalid API token' do
      _(proc do
        TrailSmith::Openai::OpenaiAPI.new('BAD_TOKEN').generate_text(QUESTION)
      end).must_raise TrailSmith::Openai::OpenaiAPI::Response::Unauthorized
    end
  end
end
