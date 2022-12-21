# frozen_string_literal: true

class ShuffleSprintDevelopers < ApplicationService
  require 'round_robin_tournament'

  attr_accessor :sprint, :project, :current_user, :view_schedule

  def initialize(params)
    @sprints = params[:sprints].to_i if params[:sprints].present?
    @project = Project.with_sprints(params[:project_id])
    @current_user = User.find_by(id: params[:current_user_id])
    @view_schedule = params[:generate_schedule]
  end

  def call
    return generate_sprint_schedules if view_schedule

    project.sprints.any? ? update_project_sprints : create_new_sprints
  end

  private

  def create_new_sprints(difference = nil)
    last_version = difference.nil? ? total_sprints : 0
    sprint_versions = [*last_version.succ..sprints]
    project_sprint_name = project.name.split.map(&:first).join.upcase

    sprints = sprint_versions.map do |sprint|
      [{ name: "#{project_sprint_name}-sprint-#{sprint}" }]
    end

    project.sprints.create(sprints)
  end

  def update_project_sprints
    difference = (sprints - total_sprints)
    project.sprints.order('created_at DESC').limit(difference.abs).destroy_all if difference.negative?
    create_new_sprints(difference) if difference.positive?
  end

  def generate_sprint_schedules
    developers = project.project_developer_ids(current_user)
    team_pairs_for_sprints = make_unique_pairs(developers)

    (total_sprints - team_pairs_for_sprints.count).times do |index|
      team_pairs_for_sprints << team_pairs_for_sprints[index % total_sprints]
    end
    team_pairs_for_sprints
  end

  def make_unique_pairs(developers)
    RoundRobinTournament.schedule(developers)
  end

  def total_sprints
    project.sprints.size
  end
end
