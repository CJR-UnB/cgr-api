FactoryBot.define do
    factory :user do 
        name { "Neiralay" }
        email { "neiralay@gmail.com" }
        password { "popao123" }
        password_confirmation { "popao123" }
    end

    factory :admin, class: User do 
        name {"Alice"}
        email {"alcebories@cjr.org.br"}
        password { "123popao" }
        password_confirmation { "123popao" }
        admin { true }
    end 
end