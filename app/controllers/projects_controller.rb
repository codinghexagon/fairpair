# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, except: %i[index create new]

  def index
    @projects = current_user.projects.id_ordered_desc
    @developers = current_user.subordinates.id_ordered_desc
  end

  def show
    @developers = User.where(id: @project.project_developers(current_user))
    @sprints = @project.sprints.count
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = current_user.projects.create(project_params)

    render :new, status: :unprocessable_entity unless @project

    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
      format.turbo_stream
    end
  end

  def update
    if @project.update(project_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    redirect_to projects_path, flash: { failure: 'Project cant be deleted' } unless @project.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Project was successfully destroyed.' }
      format.turbo_stream
    end
  end

  def manage_developers
    kaput_developer_ids = current_user.subordinates
                                      .where.not(id: @project.project_developers(current_user))
    @developers = User.where(id: kaput_developer_ids)
  end

  def add_developer
    user = fetch_developer
    @project.user_projects.create(user: user)
    redirect_back fallback_location: manage_developers_project_path(@project)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def fetch_developer
    User.find_by(id: params[:developer_id])
  end

  def set_project
    @project = Project.preload(:user_projects).find_by(id: params[:id])
  end
end
