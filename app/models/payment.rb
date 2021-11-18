class Payment < ApplicationRecord
    belongs_to :project , optional: true

end
