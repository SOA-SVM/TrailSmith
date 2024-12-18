# frozen_string_literal: true

require 'dry/monads'

module TrailSmith
  module Service
    # Service responsible for retrieving and formatting location plan details
    #
    # This class handles fetching a plan by its ID and preparing the data
    # for viewing, using a repository to access plan information and
    # a view builder to transform the raw data into a presentation-ready format.
    #
    # @param repository [Repository] The data access repository for retrieving plans
    class ViewLocation
      include Dry::Monads::Result::Mixin

      def initialize(repository = Repository::For)
        @repository = repository
      end

      def call(plan_id)
        find_plan(plan_id).bind do |plan|
          Success(ViewBuilder.build(plan))
        end
      rescue StandardError => error
        log_error('Database error', error)
        Failure('Could not access database')
      end

      private

      def find_plan(plan_id)
        plan = @repository.klass(Entity::Plan).find_id(plan_id)
        plan ? Success(plan) : Failure('Plan not found')
      end
      # Similar approach to logging
      class << self
        def logger
          @logger ||= begin
            require 'logger'
            Logger.new($stdout)
          end
        end
      end
      def log_error(context, error)
        # Replace with your preferred logging mechanism
        self.class.logger.error("#{context}: #{error.message}")
      end
      # ... rest of the implementation remains the same ...
    end

    # Builds a structured view representation of a location plan
    #
    # Transforms a raw plan entity into a format suitable for frontend display,
    # including plan details, locations, polylines, and metadata.
    #
    # @param plan [Plan] The plan entity to be transformed into a view format
    class ViewBuilder
      # ... rest of the implementation remains the same ...
      def self.build(plan)
        {
          plan: plan,
          locations: build_locations(plan),
          polylines: build_polylines(plan),
          hashtag: build_hashtag(plan)
        }
      end

      def self.build_hashtag(plan)
        {
          people: plan.num_people,
          region: plan.region,
          day: plan.day
        }
      end

      def self.build_locations(plan)
        plan.spots.map { |spot| format_spot(spot) }.to_json
      end

      def self.build_polylines(plan)
        plan.routes.map(&:overview_polyline).to_json
      end

      def self.format_spot(spot)
        {
          'coordinate' => spot.coordinate.to_h,
          'title'      => spot.name
        }
      end
    end
  end
end
