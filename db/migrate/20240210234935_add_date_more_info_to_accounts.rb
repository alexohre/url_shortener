class AddDateMoreInfoToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :date_of_birth, :date
    add_column :accounts, :gender, :string
    add_column :accounts, :username, :string
    add_column :accounts, :first_name, :string
    add_column :accounts, :last_name, :string
    add_column :accounts, :phone_number, :string
    add_column :accounts, :address, :text
    add_column :accounts, :zip_code, :string
    add_column :accounts, :state, :string
    add_column :accounts, :country, :string
  end
end
