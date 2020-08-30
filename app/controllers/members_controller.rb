class MembersController < ApplicationController
  before_action :authenticate_user, only: [:update, :destroy]
  before_action :set_member, only: [:show, :update, :destroy]
  
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
    result = MemberManager::Registrate.call(member_params, opt_params)

    if result.success?
      render json: result.member, include: [:teams, :roles], status: :created, location: result.member
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /members/:id
  def update
    result = MemberManager::Update.call(@current_user, @member, member_params, opt_params)

    if result.sucess?
      render json: result.member, include: [:teams, :roles]
    else
      render json: result.errors, status: result.status
    end
  end

  # DELETE /members/:id/:hard_delete
  def destroy
    if @member != @current_user.member
      render json: { error: "Not Authorized: User must be admin OR match target user" }, status: 401 
      return 
    end
    opt_params[:hard_delete]? @member.soft_delete : @member.destroy
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end
  
  # Only allow a trusted parameter "white list" through.
  def member_params
    params.require(:member).permit(:name, :deleted_at)
  end

  def opt_params
    params.permit(:role_id, :leave_role, :hard_delete)
  end

end
