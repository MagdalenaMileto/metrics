class RemoveTypeFromMetricValues < ActiveRecord::Migration[7.0]
  def change
    remove_column :metric_values, :type
  end
end
