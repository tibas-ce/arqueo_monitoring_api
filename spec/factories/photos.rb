FactoryBot.define do
  factory :photo do
    caption { "MyString" }
    coord_e { "9.99" }
    coord_n { "9.99" }
    position { 1 }
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test_photo01.jpg"), "image/jpg") }
    association :monitoring_sheet
  end
end
