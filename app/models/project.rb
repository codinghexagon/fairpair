class Project < ApplicationRecord
    has_many :user_projects
    has_many :project, through: :user_projects
    has_many :sprints, dependent: :destroy

    validates :name, presence: true, uniqueness: { case_sensitive: false }

end
