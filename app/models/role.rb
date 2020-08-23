class Role < ApplicationRecord
    has_many :member_roles
    has_many :members, through: :member_roles
    belongs_to :team

    include SoftDeletable
    
    validates :name, uniqueness: true
    validates :team, uniqueness: true
end
