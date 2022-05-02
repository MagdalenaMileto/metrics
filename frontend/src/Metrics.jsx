import { useState } from "react";
import { Modal } from "./Modal";

const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

export function Metrics() {
  const [openMetric, setOpenMetric] = useState(null);

  const handleMetricClick = (n) => setOpenMetric(n);
  const onCloseModal = () => setOpenMetric(null);

  return (
    <>
      {openMetric && (
        <Modal metricName={openMetric} closeModal={onCloseModal} />
      )}

      <div className="metrics-grid">
        {numbers.map((n) => (
          <div
            className="metric"
            key={`metric-${n}`}
            onClick={() => handleMetricClick(n)}
          >
            {n}
          </div>
        ))}
      </div>
    </>
  );
}
