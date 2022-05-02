import "./App.css";
import { SearchBar } from "./SearchBar";
import { Metrics } from "./Metrics";

function App() {
  return (
    <div className="app">
      <SearchBar
        onMetricName={(name) => {
          fetchMetrics(name).then(console.log);
        }}
      />
      <Metrics />
    </div>
  );
}

function fetchMetrics(name) {
  const url = new URL("http://localhost:3000/api/metrics/");
  return fetch("http://localhost:3000/api/metrics")
    .then((response) => response.json())
    .catch((error) => {
      console.error(error);
      throw error;
    });
}

export default App;
