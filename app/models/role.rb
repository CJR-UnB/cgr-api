class Role < ApplicationRecord
    has_many :member_roles
    has_many :members, through: :member_roles
    belongs_to :team
    
    validates :name, uniqueness: true
end
