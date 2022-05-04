class MetricsController < ApplicationController

  def index
    name_like = params[:name]
    if name_like.nil? || name_like.empty?
      @metrics = Metric.all
    else
      @metrics = Metric.where("name LIKE ?", "%#{name_like}%")
    end
  end

  def average
    metric_name = params[:name]
    start_date = params[:startDate]
    end_date = params[:endDate]
    resolution = metric_resolution

    return render plain: 'resolution is invalid', status: :bad_request if resolution.nil?
    return render plain: 'name is missing', status: :bad_request if metric_name.nil?
    return render plain: 'start date is missing', status: :bad_request if start_date.nil?
    return render plain: 'end date is missing', status: :bad_request if end_date.nil?

    @metric_name = metric_name
    @resolution = resolution
    @bucketed_metric_values = BucketedMetricAverage.average(metric_name, resolution, start_date, end_date)
  end

  def register
    CreateMetricValue.register(metric_params[:name], metric_params[:value], metric_params[:timestamp])
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