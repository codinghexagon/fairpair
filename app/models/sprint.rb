class Sprint < ApplicationRecord
  belongs_to :project
  has_one :schedule, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
