module MemberManager
    class Update < ApplicationService
        
        attr_reader :current_user, :member, :member_params

        def initialize(current_user, member, params = {}, options = {})
            
            @current_user = current_user
            @member = member
            @params = params
            @options = options

            set_defaults
            check_roles
        end 

        def execute
            return OpenStruct.new(success?: false,
                member: nil,
                errors: {error: "Not Authorized: User must be admin OR the same as target"},
                status: :unauthorized) unless can_update?
            
            return OpenStruct.new(success?: false, 
                member: nil, 
                errors: @member.errors, 
                status: :unprocessable_entity) unless @member.update(@params)

            OpenStruct.new(success?: true, 
                    member: @member, 
                    errors: nil,
                    status: :ok)
        end 

        private 

        def set_defaults
            @defaults = {}
            @defaults[:team] = Team.find_or_create_by(name: 'Visitantes')
            @defaults[:role] = Role.find_or_create_by({name: 'Visitante', team: @defaults[:team]})
        end

        def check_roles
            return @member.join_role(@defaults[:role].id) unless @options[:roles] 

            @options[:roles].each do |role|
                role[:leave_role] ? @member.leave_role(role[:id]) : @member.join_role(role[:id])
            end
            @member.reload
        end

        # Para atualizar as informações de um membro, o usuário deve ser admin
        # ou o próprio membro que está sendo editado. 
        def can_update?
            @current_user.member == @member  || @current_user.is_admin?
        end

    end 
end