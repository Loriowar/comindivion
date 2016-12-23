export default function initializeDatepickers() {
  // TODO: Display a human-readable date
  let options = {
    // Default format for Ecto.Date
    // Example: '2014-12-31'
    dateFormat: 'Y-m-d',
    allowInput: true
  }
  flatpickr('.datepicker', options);
}
