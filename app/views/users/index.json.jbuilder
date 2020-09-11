json.array! @users do |user|
    json.name user.name
    json.email user.email
    json.admin user.admin
    json.created_at user.created_at
    if user.member
        member = user.member
        json.member do
            json.name member.name 
            if member.roles.any?
                json.roles member.roles do |role|
                    json.name role.name 
                    json.entry_date role.entry_date 
                end 
            end
            if member.teams.any?
                json.teams member.teams do |team|
                    json.name team.name 
                    json.initials team.initials 
                end
            end
        end
    end
end