require "rails_helper"

describe MetricsController, type: :controller do

  describe '#register' do
    let(:metric) { Metric.create(name: 'temperature') }

    it 'http status is no content' do
      post :register, params: { name: metric.name, value: 37, timestamp: Time.now }
      expect(response).to have_http_status(:no_content)
    end

    it "creates a metric value" do
      now = Time.now.round
      post :register, params: { name: metric.name, value: 37, timestamp: now }
      expect(MetricValue.count).to eq(1)
      expect(MetricValue.first).to have_attributes(value: 37, timestamp: now)
      expect(MetricValue.first.metric).to eq(metric)
    end

    it "upserts metric when not present" do
      post :register, params: { name: 'temperature', value: 37, timestamp: Time.now }
      expect(Metric.count).to eq(1)
      expect(Metric.first).to have_attributes(name: 'temperature')
    end
  end

  describe '#index' do
    it 'http status is ok' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns empty when no metrics present' do
      get :index

      expect(json_response).to include(:metrics)
      expect(json_response[:metrics]).to be_empty
    end

    it 'serializes each metric' do
      Metric.create(name: 'temperature')
      Metric.create(name: 'humidity')
      Metric.create(name: 'wind')

      get :index

      response_metrics = json_response[:metrics]

      expect(response_metrics).to eq([
                                       { :name => "temperature" },
                                       { :name => "humidity" },
                                       { :name => "wind" }
                                     ])
    end
    it 'filters metric by name' do
      Metric.create(name: 'temperature')
      Metric.create(name: 'temperature_fahrenheit')
      Metric.create(name: 'wind')

      get :index, params: {name: 'temp'}

      response_metrics = json_response[:metrics]

      expect(response_metrics).to eq([
                                       { :name => "temperature" },
                                       { :name => "temperature_fahrenheit" },
                                     ])
    end
  end

  describe '#average' do
    let(:metric) { Metric.create!(name: 'temperature') }

    it 'returns http status bad request when startDate is missing' do
      get :average, params: { name: 'temperature', endDate: Time.now }

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http status bad request when endDate is missing' do
      get :average, params: { name: 'temperature', startDate: Time.now }

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http status not found when metrics does not exist' do
      get :average, params: { name: 'temperature', startDate: Time.now - 1, endDate: Time.now }

      expect(response).to have_http_status(:not_found)
    end

    it 'returns http status is ok when metrics exists' do
      Metric.create!(name: 'temperature')

      get :average, params: { name: 'temperature', startDate: Time.now - 1, endDate: Time.now }

      expect(response).to have_http_status(:ok)
    end

    it 'returns http status bad request when resolution is invalid' do
      get :average, params: { name: 'temperature', resolution: 'week' }

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http status bad request when name is missing' do
      get :average

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns bucketed metrics' do
      start_date = Time.zone.local(2022, 4, 30, 12, 10, 10)
      end_date = Time.zone.local(2022, 4, 30, 12, 15, 20)

      metric_value_1 = MetricValue.create!(metric: metric, value: 10, timestamp: start_date)
      metric_value_2 = MetricValue.create!(metric: metric, value: 5, timestamp: end_date)

      post :register, params: { name: metric.name, value: metric_value_1.value, timestamp: metric_value_1.timestamp }
      post :register, params: { name: metric.name, value: metric_value_2.value, timestamp: metric_value_2.timestamp }

      expected_time_bucket = Time.zone.local(2022, 4, 30, 12, 0, 0)

      get :average, params: { name: metric.name, startDate: expected_time_bucket, endDate: end_date }

      expect(json_response).to eq(name: 'temperature', resolution: 'hour', metricValues: [{ timeBucket: expected_time_bucket.utc.iso8601, average: 7.5 }])
    end
  end
end

def json_response
  JSON.parse(response.body, { :symbolize_names => true })
end
