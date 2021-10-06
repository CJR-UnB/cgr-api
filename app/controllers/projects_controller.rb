class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.includes(:team_id, :roles, :members)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    if @project.save
      render :show, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update(project_params)
      render :show, status: :ok, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:team_id, :payment_id, :name, :client_info, :project_info, :deleted_at)
    end
end
