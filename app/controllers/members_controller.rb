class MembersController < ApplicationController
  before_action :set_member, only: [:show, :update, :destroy]
  before_action :check_roles, only: [:update]
  
  include MemberManager

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
    result = MemberManager::Register.call(member_params, optional_params)

    if result.success?
      render json: result.member, include: [:teams, :roles], status: :created, location: result.member
    else
      render json: result.errors, status: :unprocessable_entity
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

  def optional_params
    params.permit(:role_id, :leave_role)
  end

end
