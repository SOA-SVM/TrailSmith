# frozen_string_literal: true

require 'google-maps'
require 'yaml'
require 'irb'

config = YAML.safe_load_file('config/secrets.yml')
GOOGLE_MAPS_KEY = config['development']['GOOGLE_MAPS_KEY']

Google::Maps.configure do |conf|
  conf.authentication_mode = Google::Maps::Configuration::API_KEY
  conf.api_key = GOOGLE_MAPS_KEY
end

# Place IDs
nthu = 'ChIJB7ZNzXI2aDQREwR22ltdKxE'
hsinchu_station = 'ChIJBXLgwuk1aDQRuu4aKYS0jF4'
hsinchu_zoo = 'ChIJl78Wnt01aDQRz1shOsBVUGU'
big_city = 'ChIJQyv318Q1aDQRYz_krC4mdb4'

# Set route
origin = Google::Maps.place(nthu)
destination = Google::Maps.place(big_city)
way_point1 = Google::Maps.place(hsinchu_station)
way_point2 = Google::Maps.place(hsinchu_zoo)
mode = 'walking' # mode：'driving', 'walking', 'bicycling', 'transit'

route = Google::Maps::Route.new(
  origin,
  destination,
  mode:,
  waypoints: [way_point1, way_point2],
  optimizeWaypoints: true
)

file_path = 'spec/fixtures/maps_gem_results.yml'
File.write(file_path, route.to_yaml)
