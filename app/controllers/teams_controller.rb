class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :update, :destroy]

  include TeamManager

  # GET /teams
  def index
    @teams = Team.all

    render json: @teams, include: [:roles]
  end

  # GET /teams/1
  def show
    render json: @team, include: [:roles]
  end

  # POST /teams
  def create
    result = TeamManager::Registrate.call(team_params, roles_params)

    if result.success?
      render json: result.team, status: :created, location: result.team
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    if @team.soft_delete
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :initials)
    end

    def roles_params
      roles = params.fetch(roles, [])
      roles_params = []
      roles.each do |r| 
        roles_params += r.permit(:name, :leader)
      end 
      roles_params
    end
end
