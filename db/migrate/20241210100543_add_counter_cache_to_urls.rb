class AddCounterCacheToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :clicks_count, :integer, default: 0, null: false
    add_column :urls, :scanned_qr_count, :integer, default: 0, null: false
  end
end
