class AddProjectToMonitoringSheets < ActiveRecord::Migration[8.1]
  def change
    add_reference :monitoring_sheets, :project, null: false, foreign_key: true
  end
end
