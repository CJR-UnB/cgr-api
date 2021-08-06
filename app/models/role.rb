class Role < ApplicationRecord
    has_many :member_roles
    has_many :members, through: :member_roles
    has_many :children, class_name: 'Role', foreign_key: 'parent_id'
    belongs_to :team
    belongs_to :parent, class_name: 'Role', optional: true

    include SoftDeletable
    
    validates :name, presence: true
    validates :team, presence: true
end
