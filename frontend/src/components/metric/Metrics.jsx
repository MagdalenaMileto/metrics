import "./Metrics.css";
import { useState } from "react";
import { MetricModal } from "./MetricModal";

export function Metrics({ metrics }) {
  const [openMetric, setOpenMetric] = useState(null);

  const handleMetricClick = (metricName) => setOpenMetric(metricName);
  const onCloseModal = () => setOpenMetric(null);

  return (
    <>
      {openMetric && (
        <MetricModal metricName={openMetric} closeModal={onCloseModal} />
      )}

      <div className="metrics-grid">
        {metrics.map(({ name }) => (
          <div
            className="metric"
            key={`metric-${name}`}
            onClick={() => handleMetricClick(name)}
          >
            {name}
          </div>
        ))}
      </div>
    </>
  );
}
