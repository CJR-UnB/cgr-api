class MembersController < ApplicationController
  before_action :set_member, only: [:show, :update, :destroy]

  # GET /members
  def index
    @members = Member.includes(:teams, :roles)

    render json: @members, include: [:teams, :roles]
  end

  # GET /members/1
  def show
    render json: @member, include: [:teams, :roles]
  end

  # POST /members
  def create
    @member = Member.new(member_params)

    if params[:role_id]
      @member.join_team(params[:role_id])
    end

    if @member.save
      render json: @member, status: :created, location: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /members/1
  def update
    if params[:role_id]
      @member.join_team(params[:role_id])
    end

    if @member.update(member_params)
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /members/1
  def destroy
    if @member.destroy
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.includes(:teams, :roles).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def member_params
      params.require(:member).permit(:name, :entry_date, :leaving_date, :role_id)
    end
end
