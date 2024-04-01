class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.string :title
      t.string :long_url
      t.string :short_url
      t.string :short_code
      t.integer :click_count, default: 0
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
