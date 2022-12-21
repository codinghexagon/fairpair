# frozen_string_literal: true

class ManageDeveloper < ViewComponent::Base
  with_collection_parameter :developer

  attr_reader :developer

  def initialize(developer: nil, project: nil)
    super
    @developer = developer
    @project = project
  end
end
