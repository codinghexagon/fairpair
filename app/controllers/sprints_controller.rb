class SprintsController < ApplicationController
    # include ShuffleSprintDevelopers

    before_action :set_project
    # def new
    #     @sprint = Sprint.new
    # end

    def create
        project_devs = @project.user_projects.where.not(user_id: current_user.id)
        previous_sprints = @project.sprints.count
        debugger
        if project_devs.blank? || previous_sprints.eql?(params["sprints"].to_i)
            redirect_back fallback_location: project_path(@project)
        else
            service_params = { project_id: @project.id, sprints: params["sprints"], current_user_id: @current_user.id }
            response = ShuffleSprintDevelopers.new(service_params).call
        end
    end

    # def show
    # end

    # def edit
    # end

    # def update
    # end

    private

    def set_project
        @project = Project.find_by(id: params[:project_id])
    end
end
