# frozen_string_literal: true

require 'http'
require 'yaml'

text_search = lambda do |config, text_query|
  url = 'https://places.googleapis.com/v1/places:searchText'
  place_info = 'places.id,places.displayName,places.types'
  report_info = 'places.rating,places.reviews,places.userRatingCount'
  HTTP.headers(
    'X-Goog-Api-Key'   => config['GOOGLE_MAPS_KEY'],
    'X-Goog-FieldMask' => "#{place_info},#{report_info}"
  ).post(url, json: { textQuery: text_query })
end

config = YAML.safe_load_file('config/secrets.yml')

maps_response = {}
maps_results = {}

# HAPPY project request
text_query = 'NTHU'
maps_response[text_query] = text_search.call(config['development'], text_query)
spot = maps_response[text_query].parse['places'][0]

## change the naming convention from camelCase into snake_case
maps_results[:place_id] = spot['id']
maps_results[:name] = spot['displayName']['text']
maps_results[:rating] = spot['rating']
maps_results[:rating_count] = spot['userRatingCount']
maps_results[:reports] = spot['reviews'].map do |review|
  {
    publish_time: review['publishTime'],
    rating: review['rating'].to_f,
    text: review['originalText']['text']
  }
end

File.write('spec/fixtures/maps_results.yml', maps_results.to_yaml)
