import "./App.css";
import { SearchBar } from "./SearchBar";
import { Metrics } from "./Metrics";
import { useCallback, useEffect, useState } from "react";

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

function fetchMetrics(name) {
  const url = new URL("http://localhost:3000/api/metrics/");
  name && url.searchParams.set("name", name);
  return fetch(url.toString())
    .then((response) => response.json())
    .then(({ metrics }) => metrics)
    .catch((error) => {
      console.error(error);
      throw error;
    });
}

export default App;
