export function fetchMetricAverages(name, resolution, startDate, endDate) {
  const url = new URL("http://localhost:3000/api/metrics/average");
  url.searchParams.set("name", name);
  url.searchParams.set("resolution", resolution);
  url.searchParams.set("startDate", startDate);
  url.searchParams.set("endDate", endDate);
  return fetch(url.toString())
    .then((response) => response.json())
    .catch((error) => {
      console.error(error);
      throw error;
    });
}

export function fetchMetrics(name) {
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
