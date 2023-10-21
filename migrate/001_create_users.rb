# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :name, null: false
      String :email, null: false
      String :password, null: false
      Boolean :admin, null: false, default: false
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :deleted_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
