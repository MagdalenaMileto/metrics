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
  end
end

def json_response
  JSON.parse(response.body, { :symbolize_names => true })
end
