FactoryBot.define do
  factory :photo do
    monitoring_sheet { nil }
    caption { "MyString" }
    coord_e { "9.99" }
    coord_n { "9.99" }
    position { 1 }
  end
end
