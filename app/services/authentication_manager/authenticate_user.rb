module AuthenticationManager
    class AuthenticateUser < ApplicationService
        
        def initialize(email, password)
            @email = email 
            @password = password
        end 

        def execute()
            return OpenStruct.new( success?: false, 
                result: nil, 
                errors: user.errors) unless user
            OpenStruct.new(success?: true, 
                result: JsonWebToken.encode(user_id: user.id), 
                errors: nil)
        end

        private 

        attr_accessor :email, :password

        def user
            user = User.find_by(email: email)
            return user if user && user.authenticate(password)
        
            errors.add :user_authentication, 'invalid credentials'
            nil
        end
    end
end