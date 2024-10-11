#  frozen_string_literal: true

require 'http'
require 'yaml'

def trans_api_path
  'https://translation.googleapis.com/language/translate/v2'
end

def send_translation_request(api_key, source_texts, target_language)
  HTTP.post(
    trans_api_path,
    params: {
      q: source_texts,
      target: target_language,
      key: api_key
    }
  )
end

config = YAML.safe_load_file('config/secrets.yml')
api_key = config['Google_Translation_Token']

texts = [
  'Hello, world!', # test_en
  '天気がいいから、散歩しましょう。', # test_ja
  "C'est la vie", # test_fr
  'Eso si que es' # test_es
]
target_language = 'zh-TW'

response = send_translation_request(api_key, texts, target_language).parse

translations = response['data']
file_path = 'spec/fixtures/translation_results.yml'

File.write(file_path, translations.to_yaml)

puts 'Translation result saved to spec/fixtures/translation-results.yml'
