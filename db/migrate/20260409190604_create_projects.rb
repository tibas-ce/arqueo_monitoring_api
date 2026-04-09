class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :ordinance_number
      t.string :municipality
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
