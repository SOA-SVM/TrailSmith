# frozen_string_literal: false

module TrailSmith
  module GoogleMaps # rubocop:disable Style/Documentation
    # build spot entity
    class SpotMapper
      def initialize(key)
        @gateway = GoogleMaps::Api.new(key)
      end

      def build_entity(text_query)
        spot = @gateway.place_data(text_query)

        Entity::Spot.new(
          id: nil,
          place_id: spot['id'],
          name: spot['displayName']['text'],
          rating: spot['rating'],
          rating_count: spot['userRatingCount'],
          reports: build_report_array(spot['reviews'])
        )
      end
    end

    def build_report_array(report_array)
      report_array.map do |report|
        Entity::Report.new(
          publish_time: report['publishTime'],
          rating: report['rating'].to_f,
          text: report['originalText']['text']
        )
      end
    end
  end
end
