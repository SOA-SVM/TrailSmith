# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock/minitest'

require_relative 'lib/gateways/openai_api'

QUESTION = 'What is the capital of France?'
EXPECTED_RESPONSE = 'Paris'
CONFIG = YAML.safe_load_file('config/secrets.yml')
# binding.irb
OPENAI_TOKEN = CONFIG['development']['OPENAI_TOKEN']
CORRECT = YAML.safe_load_file('spec/fixtures/openai_response.yml')

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'openai_api'

VCR.configure do |config|
  config.cassette_library_dir = CASSETTES_FOLDER
  config.hook_into :webmock
  config.filter_sensitive_data('<OPENAI_TOKEN>') { OPENAI_TOKEN }
  config.filter_sensitive_data('<OPENAI_TOKEN_ESC>') { CGI.escape(OPENAI_TOKEN) }
end
