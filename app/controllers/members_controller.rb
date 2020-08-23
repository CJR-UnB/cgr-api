class MembersController < ApplicationController
  before_action :set_member, only: [:show, :update, :destroy]
  before_action :check_roles, only: [:update]
  
  # GET /members
  def index
    @members = Member.includes(:teams, :roles)
    render json: @members, include: [:teams, :roles]
  end

  # GET /members/:id
  def show
    render json: @member, include: [:teams, :roles]
  end

  # POST /members
  def create
    @member = Member.new(member_params)

    if params[:role_id]
      @member.join_role(params[:role_id])
    end

    if @member.save
      render json: @member, include: [:teams, :roles], status: :created, location: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /members/:id
  def update
    set_member
    if @member.update(member_params)
      render json: @member, include: [:teams, :roles]
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /members/:id
  def destroy
    @member.destroy
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  def check_roles 
    if params[:role_id]
      if params[:leave_role]
        @member.leave_role(params[:role_id])
      else 
        @member.join_role(params[:role_id])
      end
    end
  end
  
  # Only allow a trusted parameter "white list" through.
  def member_params
    params.require(:member).permit(:name, :deleted_at)
  end

end
