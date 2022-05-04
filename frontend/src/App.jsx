import "./App.css";
import { SearchBar } from "./components/SearchBar";
import { Metrics } from "./components/metric/Metrics";
import { useCallback, useEffect, useState } from "react";
import { fetchMetrics } from "./api-calls";

function App() {
  const [metrics, setMetrics] = useState([]);

  useEffect(() => {
    fetchMetrics().then(setMetrics);
  }, []);

  const onMetricCallback = useCallback((name) => {
    fetchMetrics(name).then(setMetrics);
  }, []);

  return (
    <div className="app">
      <SearchBar onMetricName={onMetricCallback} />
      <Metrics metrics={metrics} />
    </div>
  );
}

export default App;
