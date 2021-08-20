module TeamManager
    class Registrate < ApplicationService

        def initialize(team_params = {}, roles_params = [])
            @team = Team.new(team_params)
            @roles_params = roles_params
        end 

        def execute
            return OpenStruct.new(  success?: false, 
                team: nil, 
                errors: @team.errors) unless create_team 
            OpenStruct.new(success?: true, team: @team, errors: nil)
        end

    private

        def create_team 
            return unless @team.save 
            unless @roles_params.empty?
                @roles_params.each do |role_params| 
                    Role.create(name: role_params[:name], team: @team)
                end
                @team.reload 
            end
            @team
        end 
    end
end