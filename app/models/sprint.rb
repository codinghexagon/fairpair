# frozen_string_literal: true

class Sprint < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
