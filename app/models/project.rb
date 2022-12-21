# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :user_projects, dependent: :destroy
  has_many :project, through: :user_projects
  has_many :sprints, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def project_developers(current_user)
    user_projects.where.not(user_id: current_user.id).pluck(:user_id).uniq
  end
end
