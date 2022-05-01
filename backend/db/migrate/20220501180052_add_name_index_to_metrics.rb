class AddNameIndexToMetrics < ActiveRecord::Migration[7.0]
  def change
    add_index :metrics, :name, unique: true
  end
end
