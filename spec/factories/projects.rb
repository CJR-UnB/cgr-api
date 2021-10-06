FactoryBot.define do
  factory :project do
    team_id { nil }
    payment_id { nil }
    name { "MyString" }
    client_info { "MyString" }
    project_info { "MyString" }
    deleted_at { "2021-09-29 11:35:26" }
  end
end
