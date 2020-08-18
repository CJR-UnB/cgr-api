class MembersController < ApplicationController
  before_action :set_member, only: [:show, :update, :destroy]
  before_action :check_roles, only: [:update]
  
  # GET /members/:scope
  def index
    @members = Member.check_scope(params[:scope]) 
    render json: @members, include: [:teams, :roles]
  end

  # GET /members/:scope/:id
  def show
    render json: @member, include: [:teams, :roles]
  end

  # POST /members/:scope
  def create
    @member = Member.new(member_params)

    if params[:role_id]
      @member.join_role(params[:role_id])
    end

    if @member.save
      render json: @member, status: :created, location: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /members/:scope/:id
  def update
    set_member
    if @member.update(member_params)
      render json: @member, include: [:teams, :roles]
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /members/:scope/:id
  def destroy
    if @member.destroy
      render json: @member, include: [:teams, :roles]
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.check_scope(params[:scope]).find(params[:id])
  end

  def check_roles 
    if params[:role_id]
      if params[:leave_role]
        @member.leave_role(Integer(params[:role_id]))
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
