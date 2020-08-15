class Member < ApplicationRecord
    has_many :member_roles, inverse_of: :member
    has_many :roles, through: :member_roles
    has_many :teams, through: :roles

    validates :name, uniqueness: true;

    include SoftDeletable

    def join_team(role_id)
        MemberRole.find_or_create_by!({member_id: self.id, role_id: role_id})
    end
end
