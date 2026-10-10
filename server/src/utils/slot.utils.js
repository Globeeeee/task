export function normalizeSlot(raw) {
  const d = new Date(raw);
  if (isNaN(d.getTime())) return null;
  const m = d.getUTCMinutes();
  if (m !== 0 && m !== 30) return null;
  d.setUTCSeconds(0, 0);
  return d;
}

export default { normalizeSlot };
