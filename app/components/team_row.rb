# frozen_string_literal: true

class TeamRow < ViewComponent::Base
  with_collection_parameter :schedule
  attr_reader :schedule, :schedule_counter, :team_member

  def initialize(schedule: nil)
    super
    @schedule = schedule
  end

  def first_member
    User.find_by(id: @schedule.first)&.user_name || 'N/A'
  end

  def second_member
    User.find_by(id: @schedule.last)&.user_name || 'N/A'
  end
end
