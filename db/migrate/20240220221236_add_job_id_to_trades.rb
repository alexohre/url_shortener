class AddJobIdToTrades < ActiveRecord::Migration[7.0]
  def change
    add_column :trades, :job_id, :string
  end
end
