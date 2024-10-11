# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/cloud_api'

TEXTS = [
  'Hello, world!', # test_en
  '天気がいいから、散歩しましょう。', # test_ja
  "C'est la vie", # test_fr
  'Eso si que es' # test_es
].freeze
TARGET_LANGUAGE = 'zh-TW'
CONFIG = YAML.safe_load_file('config/secrets.yml')
CLOUD_TOKEN = CONFIG['Google_Translation_Token']
CORRECT = YAML.safe_load_file('spec/fixtures/translation_results.yml')

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'cloud_api'
