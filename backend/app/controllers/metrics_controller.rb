class MetricsController < ApplicationController
  def register
    metric = Metric.find_or_create_by!(name: params[:name])
    MetricValue.create!(metric_value_params(metric))
  end

  private

  def metric_value_params(metric)
    metric_params.permit(:timestamp, :value).merge!(metric: metric)
  end

  def metric_params
    params.permit(:timestamp, :value, :name)
  end
end
