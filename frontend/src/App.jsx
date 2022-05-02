import "./App.css";
import { SearchBar } from "./SearchBar";
import { Metrics } from "./Metrics";

function App() {
  return (
    <div className="app">
      <SearchBar
        onMetricName={(name) => {
          console.log(name);
          fetchMetrics().then(console.log);
        }}
      />
      <Metrics />
    </div>
  );
}

function fetchMetrics() {
  return fetch("http://localhost:3000/api/metrics").then((response) =>
    response.json()
  );
}

export default App;
