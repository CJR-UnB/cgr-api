class Team < ApplicationRecord
    has_many :members, through: :roles
    has_many :roles
    
    validates :name, uniqueness: true
end
