class AddMetricValueVallue < ActiveRecord::Migration[7.0]
  def change
    add_column :metric_values, :value, :integer
  end
end
