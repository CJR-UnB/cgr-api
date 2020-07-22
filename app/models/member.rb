class Member < ApplicationRecord
    has_many :teams, through: :member_teams
    has_many :roles, through: :member_teams

    validates :name, uniqueness: true;

    def role_in(team)
        MemberTeam.where({member_id: self.id, team_id: team.id}).role
    end 
end
