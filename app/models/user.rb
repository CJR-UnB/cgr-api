class User < ApplicationRecord
    has_secure_password
    has_one :member

    validates :name, uniqueness: true

    def is_admin?
        self.admin
    end
end
