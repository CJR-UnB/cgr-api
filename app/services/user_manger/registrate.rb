module UserManager
    class Registrate < ApplicationService

        include MemberManager

        def initialize(user_params = {}, member_params = {})
            @user = User.new(user_params)
            
            if member_params
                member = MemberManager::Registrate.call(@member_params)
                @user.member = member 
            end
        end 

        def execute
            return OpenStruct.new(  success?: false, 
                user: nil, 
                errors: @user.errors) unless @user.save
            OpenStruct.new(success?: true, user: @user, errors: nil)
        end
    end
end