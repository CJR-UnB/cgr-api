class RolesController < ApplicationController
  before_action :set_role, only: [:show, :update, :destroy]
  before_action :set_team, only: [:index]

  # GET /teams/:team_id/roles
  def index
    @roles = @team.roles

    render json: @roles
  end

  # GET /roles/:id
  def show
    render json: @role
  end

  # POST /teams/:team_id/roles
  def create
    @role = Role.new(role_params)

    if @role.save
      render json: @role, status: :created, location: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/:id
  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/:id
  def destroy
    if @role.soft_delete
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    def set_team 
      @team = Team.find(params[:team_id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :team_id, :description)
    end
end
