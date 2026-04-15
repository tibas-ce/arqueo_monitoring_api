class MonitoringSheet < ApplicationRecord
  belongs_to :project
  has_many :photos, dependent: :destroy

  COORDINATE_SYSTEM = "UTM-SIRGAS2000-ZONA24S".freeze

  before_validation :set_coordinate_system

  validates :monitoring_date,       presence: true
  validates :activity,              presence: true
  validates :stake_interval,        presence: true
  validates :lot,                   presence: true
  validates :start_x,               presence: true
  validates :start_y,               presence: true
  validates :end_x,                 presence: true
  validates :end_y,                 presence: true
  validates :work_status,           presence: true
  validates :occurrence_evaluation, presence: true
  validates :project,               presence: true

  private

  def set_coordinate_system
    self.coordinate_system = COORDINATE_SYSTEM
  end
end
