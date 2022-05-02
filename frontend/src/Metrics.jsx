import { useState } from "react";
import { Modal } from "./Modal";

export function Metrics({ metrics }) {
  const [openMetric, setOpenMetric] = useState(null);

  const handleMetricClick = (metricName) => setOpenMetric(metricName);
  const onCloseModal = () => setOpenMetric(null);

  return (
    <>
      {openMetric && (
        <Modal metricName={openMetric} closeModal={onCloseModal} />
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
