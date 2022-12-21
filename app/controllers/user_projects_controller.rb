# frozen_string_literal: true

class UserProjectsController < ApplicationController
  def destroy
    @user_project = UserProject.where(user_id: params[:developer_id], project_id: params[:project_id])
    @row = params[:developer_id]

    UserProject.destroy(@user_project.ids)

    respond_to do |format|
      format.html { redirect_to project_path(params[:project_id]), notice: 'Project was successfully destroyed.' }
      format.turbo_stream
    end
  end
end
