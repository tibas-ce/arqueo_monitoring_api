class Project < ApplicationRecord
  belongs_to :company
  has_many :monitoring_sheets

  validates :name,         presence: true
  validates :municipality, presence: true
  validates :company,      presence: true
end
