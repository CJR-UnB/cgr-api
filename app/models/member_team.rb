class MemberTeam < ApplicationRecord
    belongs_to :member
    belongs_to :team 
    has_one :role
end
