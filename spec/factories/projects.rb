FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    ordinance_number { "MyString" }
    municipality { "MyString" }
    company { nil }
  end
end
