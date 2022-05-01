class MetricsController < ApplicationController

  def index
    name_like = params[:name]
    if name_like.nil? || name_like.empty?
      @metrics = Metric.all
    else
      @metrics = Metric.where( "name LIKE ?", "%#{name_like}%")
    end
  end

  def average
    metric_name = params[:name]
    resolution = metric_resolution

    return render plain: 'resolution is invalid', status: :bad_request if resolution.nil?
    return render plain: 'name is missing', status: :bad_request if metric_name.nil?

    @metric_name = metric_name
    @resolution = resolution
    @bucketed_metric_values = BucketedMetricValue.average(metric_name, resolution)
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

  def metric_resolution
    resolution = params[:resolution] || 'hour'
    if VALID_RESOLUTIONS.include?(resolution)
      resolution
    else
      nil
    end
  end
end

VALID_RESOLUTIONS = %w[day hour minute]