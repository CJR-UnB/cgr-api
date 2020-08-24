module MemberManager
    class Register < ApplicationService

        attr_reader :member, :options

        def initialize(params = {}, options = {})
            @member = Member.new(params)
            @options = options

            set_defaults
        end

        def execute
            return OpenStruct.new(  success?: false, 
                                    member: nil, 
                                    errors: @member.errors) unless @member.save
            check_role
            OpenStruct.new(success?: true, member: @member, errors: nil)
        end

        private 
        
        def set_defaults
            @defaults = {}
            @defaults[:team] = Team.find_by(name: 'Visitantes')
            @defaults[:role] = Role.find_by({name: 'Visitante', team: @defaults[:team]})
        end

        def check_role
            if @options[:role_id]
                @member.join_role(@options[:role_id])
            else  
                @member.join_role(@defaults[:role].id)
            end
        end

    end
end