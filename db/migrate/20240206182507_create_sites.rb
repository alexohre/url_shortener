class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.string :contact_number
      t.string :contact_email
      t.text :contact_address

      t.timestamps
    end
  end
end
