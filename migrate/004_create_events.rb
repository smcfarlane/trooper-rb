# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false
      foreign_key :troop_id, :troops, on_delete: :cascade, null: false
      String :name, null: false, text: true
      String :description, null: false, text: true
      DateTime :starts_at, null: false
      DateTime :ends_at, null: false
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
