# frozen_string_literal: true

require_relative 'spec_helper_cloud'

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
      @sentences = TrailSmith::CloudTranslation::SentenceMapper.new(CLOUD_TOKEN).find(TEXTS, TARGET_LANGUAGE)
      translated_text = @sentences.translated_text
      source_language = @sentences.source_language

      correct_translated_text = CORRECT['translations'].map { |arr| arr['translatedText'] }
      correct_source_language = CORRECT['translations'].map { |arr| arr['detectedSourceLanguage'] }

      _(translated_text).must_equal correct_translated_text
      _(source_language).must_equal correct_source_language
    end

    it 'SAD: should raise exception when bad request by wrong token' do
      _(proc do
        TrailSmith::CloudTranslation::SentenceMapper.new('BAD_TOKEN').find(TEXTS, TARGET_LANGUAGE)
      end).must_raise TrailSmith::CloudTranslation::Api::Response::BadRequest
    end

    it 'SAD: should raise exception when forbidden without giving token' do
      _(proc do
        TrailSmith::CloudTranslation::SentenceMapper.new('').find(TEXTS, TARGET_LANGUAGE)
      end).must_raise TrailSmith::CloudTranslation::Api::Response::Forbidden
    end
  end
end
