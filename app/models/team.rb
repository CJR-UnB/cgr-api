class Team < ApplicationRecord
    has_many :members, through: :roles
    has_many :roles

    include SoftDeletable
    
    validates :name, uniqueness: true
end
