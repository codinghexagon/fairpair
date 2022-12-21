class ProjectsController < ApplicationController

  before_action :set_project, except: %i[index create new]

  def index
    @projects = current_user.projects
    @developers = current_user.subordinates
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.create(project_params)
    if @project
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def show
    @developers = User.where(id: @project.user_projects.where.not(user_id: current_user.id).pluck(:user_id).uniq)
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      respond_to do |format|
        format.html do
          flash[:success] = 'Project removed successfully'
          redirect_to projects_path
        end
      end
    else
      flash[:failure] = 'Project cant be deleted'
      redirect_to projects_path
    end
  end

  def manage_developers
    @devs = @project.user_projects.where.not(user_id: current_user.id).pluck(:user_id)
    developer_ids = current_user.subordinates.where.not(id: @devs)
    @developers = User.where(id: developer_ids)
  end

  def add_developer
    user = User.find_by(id: params[:developer_id])
    @project.user_projects.create(user: user)
    redirect_back fallback_location:  manage_developers_project_path(@project)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
  
  def set_project
    @project = Project.find_by(id: params[:id])
  end
end
