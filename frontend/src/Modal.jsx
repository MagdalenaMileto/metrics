import {
  CartesianGrid,
  Legend,
  Line,
  LineChart,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

const data = [
  {
    name: "Mon 1",
    temperature: 4000,
    amt: 2400,
  },
  {
    name: "Tue 2",
    temperature: 3000,
    amt: 2210,
  },
  {
    name: "Wen 3",
    temperature: 2000,
    amt: 2290,
  },
  {
    name: "Thu 4",
    temperature: 2780,
    amt: 2000,
  },
  {
    name: "Fri 5",
    temperature: 1890,
    amt: 2181,
  },
  {
    name: "Sat 6",
    temperature: 2390,
    amt: 2500,
  },
  {
    name: "Sun 7",
    temperature: 3490,
    amt: 2100,
  },
];

export function Modal({ closeModal, metricName }) {
  return (
    <div className="modal-overlay">
      <div className="metric-modal">
        <h1>Metric Modal {metricName}</h1>
        <div>
          <LineChart
            width={600}
            height={350}
            data={data}
            margin={{
              top: 5,
              right: 30,
              left: 20,
              bottom: 5,
            }}
          >
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="name" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Line type="monotone" dataKey="temperature" stroke="#82ca9d" />
          </LineChart>
        </div>
        <button onClick={() => closeModal()}>Close</button>
      </div>
    </div>
  );
}
