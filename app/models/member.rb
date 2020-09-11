class Member < ApplicationRecord
    has_many :member_roles, inverse_of: :member, dependent: :destroy
    has_many :roles, through: :member_roles
    has_many :teams, through: :roles
    belongs_to :user, optional: true

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    
    include SoftDeletable

    def join_role(role_id)
        MemberRole.find_or_create_by!({member_id: self.id, role_id: role_id})
    end

    def leave_role(role_id)
        relation = MemberRole.where({member_id: self.id, role_id: role_id})
        relation = relation.first
        if relation 
            relation.delete
        end 
    end

end
