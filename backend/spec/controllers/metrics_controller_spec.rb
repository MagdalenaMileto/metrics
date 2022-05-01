require "rails_helper"

describe MetricsController, type: :controller do
  describe '#register' do
    let(:metric) { Metric.create(name: 'temperature') }

    it 'returns no content' do
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
end
