FactoryBot.define do
  
    factory :member do
        name { "Neiralay" }
        roles { [] }
    end

    factory :user do 
        name { "Neiralay" }
        email { "neiralay@gmail.com" }
        password { "popao123" }
        password_confirmation { "popao123" }
    end

    factory :team do 
        name { "Núcleo de Talentos" }
        initials { "NUT" }
    end

    factory :role do 
        name { "Consultor de Talentos"}
        team
    end
end