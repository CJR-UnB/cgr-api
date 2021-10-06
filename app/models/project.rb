class Project < ApplicationRecord
  belongs_to :teams
  belongs_to :payments
end
