class CreateEmailers < ActiveRecord::Migration[7.0]
  def change
    create_table :emailers do |t|
      t.string :email
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
