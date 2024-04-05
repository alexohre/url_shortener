class AddShowUrlToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :show_url, :string
  end
end
