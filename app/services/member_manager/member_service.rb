module MemberManager
  class MemberService < ApplicationService

    protected

    def check_roles
      @options[:join_roles] ||= []
      @options[:leave_roles] ||= []
      
      return @member.join_role(@defaults[:role].id) unless @options[:join_roles].any? || @options[:leave_roles].any? 

      @options[:join_roles].each do |role_id|
          @member.join_roles(role_id)
      end

      @options[:leave_roles].each do |role_id|
          @member.leave_roles(role_id)
      end

      @member.reload
    end

  end
end