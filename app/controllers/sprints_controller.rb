# frozen_string_literal: true

class SprintsController < ApplicationController
  before_action :set_project

  def index
    @schedule = manage_sprint_schedule(schedule_service_params)
  end

  def create
    manage_sprint_schedule(schedule_service_params)

    redirect_back fallback_location: project_path(@project)
  end

  def manage_sprint_schedule(service_params)
    ShuffleSprintDevelopers.new(service_params).call
  end

  private

  def schedule_service_params
    {
      project_id: @project.id,
      sprints: params[:sprints],
      current_user_id: current_user.id,
      generate_schedule: params[:sprints].blank?
    }
  end

  def set_project
    @project = current_user.projects
                           .where(id: params[:project_id])
                           .with_sprints(params[:project_id])

    return redirect_to root_path if @project.nil?

    authorize @project
  end

  def authorization
    authorize Sprint
  end
end
