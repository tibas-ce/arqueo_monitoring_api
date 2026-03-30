class CreateMonitoringSheets < ActiveRecord::Migration[8.1]
  def change
    create_table :monitoring_sheets do |t|
      t.date :monitoring_date
      t.string :activity
      t.string :stake_interval
      t.string :lot
      t.decimal :start_x
      t.decimal :start_y
      t.decimal :end_x
      t.decimal :end_y
      t.string :work_status
      t.text :occurrence_evaluation
      t.string :coordinate_system

      t.timestamps
    end
  end
end
