# frozen_string_literal: true

class SprintTable < ViewComponent::Base
  with_collection_parameter :sprint
  attr_reader :sprint, :schedule, :sprint_counter

  def initialize(sprint: nil, sprint_counter: nil, schedule: nil)
    super
    @sprint = sprint
    @sprint_counter = sprint_counter
    @schedule = schedule
  end

  def team_count
    schedule.first.count
  end
end
