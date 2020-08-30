class ApplicationController < ActionController::API
    attr_reader :current_user

    include AuthenticationManager
  
    protected
  
    def authenticate_user
      @current_user = AuthenticationManager::AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized: User must be logged in' }, status: 401 unless @current_user
    end
    
end
