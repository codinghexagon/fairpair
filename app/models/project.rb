# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :sprints, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, length: 4..20, allow_blank: true
  scope :id_ordered_desc, -> { order(id: :desc) }

  def project_developer_ids(current_user)
    user_projects.where.not(user_id: current_user.id).pluck(:user_id)
  end

  def self.with_sprints(id)
    preload(:sprints).find_by(id: id)
  end
end
