class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :monitoring_sheet, null: false, foreign_key: true
      t.string :caption
      t.decimal :coord_e, precision: 12, scale: 4
      t.decimal :coord_n, precision: 12, scale: 4
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
