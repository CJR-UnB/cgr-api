class MemberRole < ApplicationRecord
    belongs_to :member
    belongs_to :role

    include SoftDeletable

    alias_attribute :leaving_date, :deleted_at
end
