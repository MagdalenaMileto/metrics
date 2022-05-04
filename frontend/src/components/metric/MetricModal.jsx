import "./MetricModal.css";
import { useCallback, useEffect, useState } from "react";
import { Chart } from "../Chart";
import { fetchMetricAverages } from "../../api-calls";

export function MetricModal({ closeModal, metricName }) {
  const [averages, setMetricAverages] = useState([]);
  const [resolution, setResolution] = useState("hour");

  const handleResolutionChange = useCallback((event) => {
    setResolution(event.target.value);
  }, []);

  useEffect(() => {
    const now = new Date();
    const sevenDaysAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    fetchMetricAverages(metricName, resolution, sevenDaysAgo, now).then(
      setMetricAverages
    );
  }, []);

  const handleSubmit = useCallback(
    (event) => {
      event.preventDefault();
      fetchMetricAverages(
        metricName,
        resolution,
        event.target.startDate.value,
        event.target.endDate.value
      ).then(setMetricAverages);
    },
    [metricName, resolution]
  );

  const todayDatePart = new Date().toISOString().split("T")[0];

  return (
    <div className="modal-overlay">
      <div className="metric-modal">
        <h2 className="metric-title">{metricName}</h2>
        <form className="search-form" onSubmit={handleSubmit}>
          <div className="label">
            <label htmlFor="resolution">resolution </label>
            <select
              name="resolution"
              value={resolution}
              onChange={handleResolutionChange}
            >
              <option value="minute">Minutes</option>
              <option value="hour">Hours</option>
              <option selected value="day">
                Days
              </option>
            </select>
          </div>
          <div className="dates">
            <div className="label">
              <label htmlFor="startDate">from</label>
              <input
                type="date"
                name="startDate"
                required
                max={todayDatePart}
              />
            </div>
            <div className="label">
              <label htmlFor="endDate">to</label>
              <input
                type="date"
                name="endDate"
                required
                max={todayDatePart}
                defaultValue={todayDatePart}
              />
            </div>
          </div>
          <input type="submit" value="Search" />
        </form>
        <Chart
          name={metricName}
          resolution={averages.resolution}
          averages={averages.metricValues}
        />
        <button className="close" onClick={() => closeModal()}>
          Close
        </button>
      </div>
    </div>
  );
}
