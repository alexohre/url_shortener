class AddFieldsToClicks < ActiveRecord::Migration[7.0]
  def change
    add_column :clicks, :region, :string
    add_column :clicks, :timezone, :string
  end
end
