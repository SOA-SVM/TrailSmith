# frozen_string_literal: false

module TrailSmith
  module GoogleMaps
    # build spot entity
    class SpotMapper
      def initialize(key)
        @gateway = GoogleMaps::Api.new(key)
      end

      def build_entity(text_query)
        @gateway.place_data(text_query)

        Entity::Spot.new(
          id: nil,
          place_id: place['id'],
          name: place['displayName']['text'],
          rating: place['rating'],
          rating_count: place['userRatingCount'],
          reports: Reports.new(place['reviews']).build_entity
        )
      end
    end

    # build report entity
    class Reports
      def initialize(reports)
        @reports = reports
      end

      def build_entity
        report_array = @reports.map do |report|
          Entity::Report.new(
            publish_time: report['publishTime'],
            rating: report['rating'].to_f,
            text: report['originalText']['text']
          )
        end
        Entity::Reports.new(report_array: report_array)
      end
    end
  end
end
