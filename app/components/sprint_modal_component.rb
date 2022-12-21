# frozen_string_literal: true

class SprintModalComponent < ViewComponent::Base
  def initialize(project: nil, sprints: nil)
    super
    @project = project
    @sprints = sprints
  end
end
