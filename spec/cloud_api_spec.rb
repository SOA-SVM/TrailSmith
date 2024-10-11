# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Test Cloud Translation API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<CLOUD_TOKEN>') { CLOUD_TOKEN }
    c.filter_sensitive_data('<CLOUD_TOKEN_ESC>') { CGI.escape(CLOUD_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Translation information' do
    it 'HAPPY: should provide correct translated attributes' do
      translation = SVM::CloudApi.new(CLOUD_TOKEN).translation(TEXTS, TARGET_LANGUAGE)
      _(translation.translations).must_equal CORRECT['translations']
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        SVM::CloudApi.new('BAD_TOKEN').translation(TEXTS, TARGET_LANGUAGE)
      end).must_raise SVM::Response::BadRequest
    end
  end
end
