# frozen_string_literal: true

class UserProjectsController < ApplicationController
  # before_action :authorization
  before_action :set_project_and_user

  def destroy
    if @developer.destroy
      respond_to do |format|
        format.html { redirect_to project_path(params[:project_id]), notice: 'Project was successfully destroyed.' }
        format.turbo_stream
      end
    end
  end

  private

  def set_project_and_user
    @project = Project.find_by(id: params[:project_id])
    @developer = @project.user_projects.find_by(user_id: params[:developer_id])
    authorize @developer
  end

  def authorization
    authorize UserProject
  end
end
