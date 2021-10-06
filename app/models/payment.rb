class Payment < ApplicationRecord
    has_one :payment, optional: true
    

end
