class CreateBucketedMetricAverages < ActiveRecord::Migration[7.0]
  def change
    create_table :bucketed_metric_averages do |t|
      t.belongs_to :metric, foreign_key: true
      t.timestamp :time_bucket
      t.integer :value_sum
      t.integer :value_count
      t.string :resolution

      t.timestamps
    end
  end
end
