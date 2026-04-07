class Photo < ApplicationRecord
  belongs_to :monitoring_sheet
  has_one_attached :image
end
