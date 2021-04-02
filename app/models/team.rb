class Team < ApplicationRecord
    has_many :members, through: :roles
    has_many :roles, dependent: :destroy

    include SoftDeletable
    
    validates :name, uniqueness: true, presence: true
    validates :initials, uniqueness: true
end
