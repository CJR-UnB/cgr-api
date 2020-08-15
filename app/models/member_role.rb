class MemberRole < ApplicationRecord
    belongs_to :member
    belongs_to :role

    include SoftDeletable

    alias_attribute :deleted_at, :leaving_date
end
