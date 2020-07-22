class MemberTeam < ApplicationRecord
  belongs_to :member
  belongs_to :team
  belongs_to :team_role
end
