module MemberManager
    class Update < ApplicationService
        
        attr_reader :current_user, :member, :member_params

        def initialize(current_user, member, member_params = {}, opt_params = {})
            
            @current_user = current_user
            @member = member
            @member_params = member_params

            check_roles(opt_params)
            @member = Member.find_by(id: @member.id)
        end 

        def execute
            
            if can_update?
                return OpenStruct.new(success?: false, 
                    member: nil, 
                    errors: @member.errors, 
                    status: :unprocessable_entity) unless @member.update(@member_params)
                OpenStruct.new(success?: true, 
                    member: @member, 
                    errors: nil,
                    status: :ok)
            else
                OpenStruct.new(success?: false,
                    member: nil,
                    errors: {error: "Not Authorized: User must be admin OR the same as target"},
                    status: :unauthorized)
            end
        end 

        private 

        def check_roles(opt_params)
            if opt_params[:role_id]
                if opt_params[:leave_role]
                    @member.leave_role(opt_params[:role_id])
                else 
                    @member.join_role(opt_params[:role_id])
                end
            end
        end

        # Para atualizar as informações de um membro, o usuário deve ser admin
        # ou o próprio membro que está sendo editado. 
        def can_update?
            @current_user.member == @member  || @current_user.is_admin?
        end

    end 
end