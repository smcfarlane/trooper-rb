# frozen_string_literal: true

class Membership < Sequel::Model
  many_to_one :user
  many_to_one :troop
end

# Table: memberships
# Columns:
#  id         | integer                     | PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY
#  user_id    | integer                     | NOT NULL
#  troop_id   | integer                     | NOT NULL
#  role       | integer                     | NOT NULL DEFAULT 0
#  current    | boolean                     | NOT NULL DEFAULT true
#  created_at | timestamp without time zone | NOT NULL DEFAULT CURRENT_TIMESTAMP
#  updated_at | timestamp without time zone | NOT NULL DEFAULT CURRENT_TIMESTAMP
# Indexes:
#  memberships_pkey | PRIMARY KEY btree (id)
# Foreign key constraints:
#  memberships_troop_id_fkey | (troop_id) REFERENCES troops(id) ON DELETE CASCADE
#  memberships_user_id_fkey  | (user_id) REFERENCES users(id) ON DELETE CASCADE