# frozen_string_literal: true

class TeamRowComponent < ViewComponent::Base
  attr_reader :schedule

  def initialize(schedule: nil, sprint_counter: nil, team_no: nil)
    super
    @schedule = schedule
    @sprint_number = sprint_counter
    @team_no = team_no
  end

  def first_member
    User.find_by(id: @schedule[@sprint_number][@team_no].first).user_name
  end

  def second_member
    User.find_by(id: @schedule[@sprint_number][@team_no].second)&.user_name || 'N/A'
  end
end
