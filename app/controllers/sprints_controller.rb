# frozen_string_literal: true

class SprintsController < ApplicationController
  before_action :set_project

  def index
    service_params = { project_id: @project.id,
                       current_user_id: current_user.id,
                       generate_schedule: true }
    @schedule = manage_sprint_schedule(service_params)
  end

  def create
    service_params = { project_id: @project.id, sprints: params['sprints'], current_user_id: current_user.id }
    manage_sprint_schedule(service_params)

    redirect_back fallback_location: project_path(@project)
  end

  def manage_sprint_schedule(service_params)
    ShuffleSprintDevelopers.new(service_params).call
  end

  private

  def set_project
    @project = Project.includes(:sprints).find_by(id: params[:project_id])
  end
end
