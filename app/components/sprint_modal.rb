# frozen_string_literal: true

class SprintModal < ViewComponent::Base
  attr_reader :project, :sprints

  def initialize(project: nil, sprints: nil)
    super
    @project = project
    @sprints = sprints
  end
end
