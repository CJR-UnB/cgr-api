class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :authenticate_user, only: [:update, :destroy]

    include UserManager

    # GET /users
    def index
        @users = User.all
        render json: @users, include: [member: [:teams, :roles]]
    end 

    # GET /users/:id
    def show 
        render json: @user, include: [member: [:teams, :roles]]
    end 

    # POST /users
    def create
        result = UserManager::Registrate.call(user_params, member_params)

        if result.success?
          render json: result.user, include: [member: [:teams, :roles]], status: :created, location: result.user
        else
          render json: result.errors, status: :unprocessable_entity
        end
    end 

    # PATCH/PUT /users/:id
    def update
        result = UserManager::Update.call(@current_user, @user, user_params, member_params)

        if result.sucess?
          render json: result.user, include: [member: [:teams, :roles]]
        else
          render json: result.errors, status: result.status
        end
    end 

    # DELETE /users/:id
    def destroy
        if @user != @current_user
            render json: { error: "Not Authorized: User must be admin OR match target user" }, status: 401 
            return 
        end
        @user.destroy
    end 

    private

    def set_user 
        @user = User.find(params[:id])
    end 

    def user_params 
        params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def member_params
        { member:  params.require(:member).permit(:name, :deleted_at),
          options:  params.permit(:role_id, :leave_role, :hard_delete)}
         
    end
    
end