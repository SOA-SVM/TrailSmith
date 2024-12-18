#  frozen_string_literal: true

require 'dry/transaction'

module TrailSmith
  module Service
    # Service to find a specific plan
    class FindPlan
      include Dry::Transaction

      step :ensure_watched_plan
      step :find_plan

      private

      # Steps

      def ensure_watched_plan(input)
        if input[:watched_list].include? input[:requested]
          Success(input)
        else
          Failure('Please first request this plan to be added to your list')
        end
      end

      def find_plan(input)
        input[:plan] = Repository::For.klass(Entity::Plan)
          .find_id(input[:requested])

        input[:plan] ? Success(input) : Failure('Plan not found')
      rescue StandardError
        Failure('Having trouble accessing the database')
      end
    end
  end
end
