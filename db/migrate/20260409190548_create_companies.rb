class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :cnpj
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
