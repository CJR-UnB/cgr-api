class User < ApplicationRecord
    has_secure_password
    has_one :member
    
    validates :email, presence: true, uniqueness: true

    def is_admin?
        self.admin
    end
end
