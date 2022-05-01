class MetricsController < ApplicationController
  include ActionController::ImplicitRender
  include ActionView::Layouts

  def index
    @metrics = Metric.all
  end

  def register
    metric = Metric.find_or_create_by!(name: metric_params[:name])
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
