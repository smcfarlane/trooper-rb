# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:memberships) do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false
      foreign_key :troop_id, :troops, on_delete: :cascade, null: false
      Integer :role, null: false, default: 0
      Boolean :current, null: false, default: true
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
