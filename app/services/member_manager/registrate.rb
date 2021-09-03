module MemberManager
    class Registrate < MemberService

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
            check_roles
            OpenStruct.new(success?: true, member: @member, errors: nil)
        end

        private 
        
        def set_defaults
            @defaults = {}
            @defaults[:team] = Team.find_or_create_by(name: 'Visitantes')
            @defaults[:role] = Role.find_or_create_by({name: 'Visitante', team: @defaults[:team]})
        end

    end
end