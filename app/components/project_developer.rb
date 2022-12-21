# frozen_string_literal: true

class ProjectDeveloper < ViewComponent::Base
  with_collection_parameter :developer

  attr_reader :developer, :project

  def initialize(developer: nil, project: nil)
    super
    @developer = developer
    @project = project
  end
end
