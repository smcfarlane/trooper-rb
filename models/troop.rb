# frozen_string_literal: true

class Troop < Sequel::Model
  one_to_many :memberships
  one_to_many :users, through: :memberships
  one_to_many :events
end

# Table: troops
# Columns:
#  id         | integer                     | PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY
#  name       | text                        | NOT NULL
#  number     | text                        | NOT NULL
#  created_at | timestamp without time zone | NOT NULL DEFAULT CURRENT_TIMESTAMP
#  updated_at | timestamp without time zone | NOT NULL DEFAULT CURRENT_TIMESTAMP
#  deleted_at | timestamp without time zone | NOT NULL DEFAULT CURRENT_TIMESTAMP
# Indexes:
#  troops_pkey | PRIMARY KEY btree (id)
# Referenced By:
#  events      | events_troop_id_fkey      | (troop_id) REFERENCES troops(id) ON DELETE CASCADE
#  memberships | memberships_troop_id_fkey | (troop_id) REFERENCES troops(id) ON DELETE CASCADE
