class ShuffleSprintDevelopers < ApplicationService
    require "round_robin_tournament"

    def initialize(params)
      @sprints = params[:sprints].to_i if params[:sprints].present?
      @project = Project.find_by(id: params[:project_id])
      @current_user = User.find_by(id: params[:current_user_id])
      @view_schedule = params[:generate_schedule]
    end
  
    def call
        return generate_sprint_schedules if @view_schedule 

        if @project.sprints.exists?
            update_project_sprints
        else
            create_new_sprints    
        end

        generate_sprint_schedules
    end


    def create_new_sprints(difference = nil)
        project_sprints = @sprints

        if difference
            last_version = get_last_sprint_version
        end
        project_name = @project.name.split.map(&:first).join.upcase

        sprint_versions = difference.present? ? [*last_version.succ..project_sprints] : [*1..project_sprints]

        sprint_versions.each do |sprint|
            sprint = @project.sprints.create(name: "#{project_name}-sprint-#{sprint.to_f}")
        end
    end

    def get_last_sprint_version
        @project.sprints.last.name.split("-")[-1].to_i
    end

    def generate_sprint_schedules
        
        project_sprints = @project.sprints
        total_sprints = project_sprints.count
        developers = @project.project_developers(@current_user)

        team_pairs_for_sprints = make_unique_pairs(developers)

        while team_pairs_for_sprints.count < total_sprints
            developers = developers.shuffle
            team_pairs_for_sprints << make_unique_pairs(developers).last
        end
        developers.delete(nil) if developers.include?(nil)
        team_pairs_for_sprints = replace_nil_from_pairs(team_pairs_for_sprints) if developers.count.odd?

        team_pairs_for_sprints
    end

    def make_unique_pairs(developers)
        RoundRobinTournament.schedule(developers)
    end

    def replace_nil_from_pairs(team_pairs_for_sprints)
        team_pairs_for_sprints.each do |sprint_teams|
            sprint_teams.each do |team|
                if team.include?(nil)
                    team.delete(nil)
                    team.push('N/A')
                end
            end
        end
    end

    def update_project_sprints
        existing_project_sprints = @project.sprints.count
        difference = (@sprints - existing_project_sprints)
        if difference.negative?
            Project.first.sprints.order('created_at DESC').limit(difference.abs).destroy_all
        else
            create_new_sprints(difference)
        end
    end

end