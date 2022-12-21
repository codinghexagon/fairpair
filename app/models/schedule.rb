class Schedule < ApplicationRecord
  belongs_to :sprint

  validates :pairs, presence: true
end
