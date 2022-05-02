export function Modal({ closeModal, metricName }) {
  return (
    <div className="modal-overlay">
      <div className="metric-modal">
        <h1>Metric Modal {metricName}</h1>
        <div>Grafiquito</div>
        <button onClick={() => closeModal()}>Close</button>
      </div>
    </div>
  );
}
