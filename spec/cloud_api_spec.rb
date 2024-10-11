# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/cloud_api'

TEXTS = [
  'Hello, world!', # test_en
  '天気がいいから、散歩しましょう。', # test_ja
  "C'est la vie", # test_fr
  'Eso si que es' # test_es
].freeze
TARGET_LANGUAGE = 'zh-TW'
CONFIG = YAML.safe_load_file('config/secrets.yml')
API_KEY = CONFIG['Google_Translation_Token']
CORRECT = YAML.safe_load_file('spec/fixtures/translation_results.yml')

describe 'Test Cloud Translation API library' do
  describe 'Translation information' do
    it 'HAPPY: should provide correct translated attributes' do
      translation = SVM::CloudApi.new(API_KEY).translation(TEXTS, TARGET_LANGUAGE)
      _(translation.translations).must_equal CORRECT['translations']
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        SVM::CloudApi.new('BAD_TOKEN').translation(TEXTS, TARGET_LANGUAGE)
      end).must_raise SVM::Response::BadRequest
    end
  end
end
