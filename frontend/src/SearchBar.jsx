import { useEffect, useState } from "react";

export function SearchBar({ onMetricName }) {
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
