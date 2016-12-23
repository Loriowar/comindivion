export default function initializeDatetimepickers() {
  // TODO: Display a human-readable date
  let options = {
    // Default format for Ecto.DateTime.
    // Example: '2014-12-31 22:50:41'
    dateFormat: 'Y-m-d H:i:S',
    allowInput: true,
    enableTime: true,
    enableSeconds: true,
    time_24hr: true
  }
  flatpickr('.datetimepicker', options);
}
