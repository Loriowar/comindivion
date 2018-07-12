export default function initializeSimpleSelect2() {
  // TODO: Display a human-readable date
  let options = {
    allowClear: true,
    width: '100%'
  };
  $('.simple-select2').select2(options);
}
