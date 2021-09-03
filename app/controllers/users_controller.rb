class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    before_action :authenticate_user, only: [:create, :update, :destroy]

    include UserManager

    # GET /users
    def index
        @users = User.all
    end 

    # GET /users/:id
    def show 
        render json: @user, include: [:member]
    end 

    # POST /users
    def create
        if @current_user.is_admin?
            result = UserManager::Registrate.call(user_params, member_params)
        else
            result = false
        end  
        if result.success?
          render json: result.user, include: [:member], status: :created, location: result.user
        else
          render json: result.errors, status: :unprocessable_entity
        end
    end 

    # PATCH/PUT /users/:id
    def update
        result = UserManager::Update.call(@current_user, @user, user_params, member_params)

        if result.sucess?
          render json: result.user, include: [:member]
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
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def member_params
        member_params = { 
                member:  params.fetch(:member, {}).permit(:name),
                options:  params.permit(:join_roles, :leave_roles, :hard_delete)
            }
        member_params ? member_params : nil
         
    end
    
end