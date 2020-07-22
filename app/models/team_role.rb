class TeamRole < ApplicationRecord
  belongs_to :role
  belongs_to :team
end
