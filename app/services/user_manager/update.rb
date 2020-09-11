module UserManager
    class Update < ApplicationService
        attr_reader :current_user, :user, :user_params, :member_params

        def initialize(current_user, user, user_params = {}, member_params = {})
            @current_user = current_user
            @user = user
            @user_params = user_params
            @member_params = member_params
        end 

        def execute
            if can_update?
                return OpenStruct.new(success?: false, 
                    user: nil, 
                    errors: @user.errors, 
                    status: :unprocessable_entity) unless @user.update(@user_params)
                update_or_create_member(@member_params)
                OpenStruct.new(success?: true, 
                    user: @user, 
                    errors: nil,
                    status: :ok)
            else
                OpenStruct.new(success?: false,
                    user: nil,
                    errors: {error: "Not Authorized: User must be admin OR the same as target"},
                    status: :unauthorized)
            end
        end 

        private 

        # Para atualizar as informações de um usuário, o usuário deve ser admin
        # ou o próprio usuário que está sendo editado. 
        def can_update?
            @current_user == @user  || @current_user.is_admin?
        end

        def update_or_create_member(member_params)
            if @user.member 
                MemberManager::Update.call(@current_user, @user.member, member_params[:member], member_params[:options])
            else  
                MemberManager::Registrate.call(member_params[:member], member_params[:options])
            end
        end
    end
end