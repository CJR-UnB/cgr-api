class AdminController < ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
        @current_user = AuthenticationManager::AuthorizeApiRequest.call(request.headers).result
        render json: { error: 'Not Authorized: User must be admin' }, status: 401 unless @current_user.is_admin?
    end
end