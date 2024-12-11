# frozen_string_literal: true

require_relative 'reports'

module TrailSmith
  module Repository
    # Repository for Reports
    class Spots
      def self.all
        Database::SpotOrm.all.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find(entity)
        # find database of entity from id
        db_record = Database::SpotOrm.find(entity.placd_id)
        rebuild_entity(db_record)
      end

      def self.rebuild_entity(db_record)
        # build entity from database
        return nil unless db_record

        Entity::Spot.new(db_record.to_hash)
      end

      def self.create(entity)
        raise 'Entity already exists in database' if find(entity)

        spot_db = Database::SpotOrm.create(entity.to_attr_hash)
        rebuild_entity(db_record)
      end
    end
  end
end
