class MonitoringSheet < ApplicationRecord
  validates :monitoring_date,       presence: true
  validates :activity,              presence: true
  validates :lot,                   presence: true
  validates :work_status,           presence: true
  validates :occurrence_evaluation, presence: true
end
