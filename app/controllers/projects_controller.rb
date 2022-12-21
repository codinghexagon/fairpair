# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, except: %i[index create new]

  def index
    @projects = current_user.projects.ordered
    @developers = current_user.subordinates.ordered
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

    if @project
      respond_to do |format|
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
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
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Project was successfully destroyed.' }
        format.turbo_stream
      end
    else
      flash[:failure] = 'Project cant be deleted'
      redirect_to projects_path
    end
  end

  def manage_developers
    kaput_developer_ids = current_user.subordinates
                                      .where.not(id: @project.project_developers(current_user))
    @developers = User.where(id: kaput_developer_ids)
  end

  def add_developer
    user = User.find_by(id: params[:developer_id])
    @project.user_projects.create(user: user)
    redirect_back fallback_location: manage_developers_project_path(@project)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.includes(:user_projects).find_by(id: params[:id])
  end
end
