class Team < ApplicationRecord
    has_many :members, through: :member_teams
    has_many :roles
    
    validates :name, uniqueness: true
end
