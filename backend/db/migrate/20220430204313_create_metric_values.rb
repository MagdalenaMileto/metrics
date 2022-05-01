class CreateMetricValues < ActiveRecord::Migration[7.0]
  def change
    create_table :metric_values do |t|
      t.belongs_to :metric, foreign_key: true
      t.integer :type
      t.timestamp :timestamp

      t.timestamps
    end
  end
end
