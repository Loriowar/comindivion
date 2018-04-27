export default function initializeVisInteractive(vis) {
  let container = document.getElementById('interactive');

  if(container !== null) {
    $.get( "api/i/f", function( data ) {
      let nodes = new vis.DataSet(data['nodes']);
      let edges = new vis.DataSet(data['edges']);
      let options = {};

      let network = new vis.Network(container, data, options);
    });
  }
}
