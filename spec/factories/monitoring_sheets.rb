FactoryBot.define do
  factory :monitoring_sheet do
    monitoring_date { "2026-03-30" }
    activity { "MyString" }
    stake_interval { "MyString" }
    lot { "MyString" }
    start_x { "9.99" }
    start_y { "9.99" }
    end_x { "9.99" }
    end_y { "9.99" }
    work_status { "MyString" }
    occurrence_evaluation { "MyText" }
    coordinate_system { "MyString" }
  end
end
