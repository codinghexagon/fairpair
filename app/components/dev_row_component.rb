# frozen_string_literal: true

class DevRowComponent < ViewComponent::Base
  with_collection_parameter :developer
  attr_reader :developer

  def initialize(developer: nil)
    super
    @developer = developer
  end
end
