class CreateClicks < ActiveRecord::Migration[7.0]
  def change
    create_table :clicks do |t|
      t.references :url, null: false, foreign_key: true
      t.string :source
      t.string :user_agent
      t.string :ip_address
      t.string :city
      t.string :country
      t.string :region
      t.string :timezone
      t.string :browser
      t.string :device
      t.string :os

      t.timestamps
    end
  end
end
