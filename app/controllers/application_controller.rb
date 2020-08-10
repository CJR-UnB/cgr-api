class ApplicationController < ActionController::API
    before_action :cors_preflight_checker
    after_filter :cors_set_access_control_headers

    protected 

    def cors_set_access_control_headers 
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'ṔOST, DELETE, GET, PUT, PATCH, OPTIONS'
        headers['Access-Control-Allow-Headers'] = '*'
        headers['Access-Control-Allow-Max-Age'] = '1728000'
    end 

    # If this is a preflight OPTIONS request, then short-circuit the
    # request, return only the necessary headers and return an empty
    # text/plain

    def cors_prelight_check 
        if request.method == :options
            headers['Access-Control-Allow-Origin'] = '*'
            headers['Access-Control-Allow-Methods'] = 'ṔOST, DELETE, GET, PUT, PATCH, OPTIONS'
            headers['Access-Control-Allow-Headers'] = '*'
            headers['Access-Control-Allow-Max-Age'] = '1728000'
            render :text => '', :content_type => 'text/plain'
        end 
    end
end
