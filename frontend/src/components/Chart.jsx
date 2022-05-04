import {
  CartesianGrid,
  Legend,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

export function Chart({ name, resolution, averages }) {
  return (
    <ResponsiveContainer width="80%">
      <LineChart data={averages}>
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="timeBucket" tick={false} />
        <YAxis />
        <Tooltip />
        <Legend />
        <Line
          type="monotone"
          dataKey="average"
          stroke="#82ca9d"
          activeDot={{ r: 8 }}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
