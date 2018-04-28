export default function initializeVisInteractive(vis) {
  let container = document.getElementById('interactive');

  if(container !== null) {
    $.get( "api/i/f", function( data ) {
      let nodes = new vis.DataSet(data['nodes']);
      // Add direction to edges
      let edges_data = data['edges'].map(
          function(el) {
            el['arrows'] = 'to';
            return el;
          });
      let edges = new vis.DataSet(edges_data);
      let network_data = {edges: edges, nodes: nodes};

      let options = {
        edges: {
          font: {
            size: 12
          },
          widthConstraint: {
            maximum: 90
          }
        },
        nodes: {
          shape: 'box',
          margin: 10,
          widthConstraint: {
            maximum: 200
          }
        },
        physics: {
          enabled: false
        },
        layout: {
          randomSeed: 6
        },
        interaction: {
          hover:true
        },
        manipulation: {
          enabled: true
        }
      };

      let network = new vis.Network(container, network_data, options);
    });
  }
}
