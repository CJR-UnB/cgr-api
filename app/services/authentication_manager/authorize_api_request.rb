module AuthenticationManager
    class AuthorizeApiRequest < ApplicationService

        def initialize(headers = {})
            @headers = headers
        end 

        def execute 
            return OpenStruct.new( success?: false, 
                result: nil, 
                errors: nil) unless user
            OpenStruct.new(success?: true, 
                result: @user, 
                errors: nil)
        end

        private

        attr_reader :headers

        def user
            @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
            @user 
            # || errors.add(:token, 'Invalid token') && nil
        end

        def decoded_auth_token
            @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
        end

        def http_auth_header
            if headers['Authorization'].present?
                return headers['Authorization'].split(' ').last
            # else
            #    errors.add(:token, 'Missing token')
            end
            nil
        end
    end
end