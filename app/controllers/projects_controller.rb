class ProjectsController < ApplicationController

  before_action :set_project, except: %i[index create new]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def show
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

  private

  def project_params
    params.require(:project).permit(:name)
  end
  
  def set_project
    @project = Project.find_by(id: params[:id])
  end
end
