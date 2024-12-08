# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:reports) do
      primary_key :id

      String :publish_time
      Float  :rating
      String :text

      DateTime :created_at
      DateTime :updated_at
    end
  end
end