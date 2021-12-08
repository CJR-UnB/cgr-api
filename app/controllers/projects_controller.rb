class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    @projects = Project.all
    
    render json: @projects, include: [:team]
  end

  # GET /projects/1
  def show
    render json: @project, include: [:team]
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      render :show, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render :show, status: :ok, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
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
