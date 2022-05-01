import { useState, useEffect } from "react";
import "./App.css";

const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

function App() {
  return (
    <div className="app">
      <SearchBar onMetricName={(name) => console.log(name)} />
      <Metrics />
    </div>
  );
}

function Modal({ closeModal }) {
  return (
    <div className="modal-overlay">
      <div className="metric-modal">
        <h1>Metric Modal</h1>
        <div>Grafiquito</div>
        <button onClick={() => closeModal()}>Close</button>
      </div>
    </div>
  );
}

function SearchBar({ onMetricName }) {
  const [inputValue, setInputValue] = useState("");

  useEffect(() => {
    let timeoutId;
    if (inputValue.length > 2) {
      timeoutId = setTimeout(() => onMetricName(inputValue), 300);
    }

    return () => {
      timeoutId && clearTimeout(timeoutId);
    };
  }, [inputValue, onMetricName]);

  const handleInputChange = (event) => {
    setInputValue(event.target.value);
  };

  return (
    <input
      placeholder="type metric name..."
      value={inputValue}
      onChange={handleInputChange}
    />
  );
}

function Metrics() {
  const [open, setOpen] = useState(false);

  const handleMetricClick = () => setOpen((openState) => !openState);
  return (
    <>
      {open && <Modal closeModal={() => setOpen(false)} />}

      <div className="metrics-grid">
        {numbers.map((n) => (
          <div
            className="metric"
            key={`metric-${n}`}
            onClick={handleMetricClick}
          >
            {n}
          </div>
        ))}
      </div>
    </>
  );
}

export default App;
