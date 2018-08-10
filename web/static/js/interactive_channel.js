export default function initializeInteractiveChannel(socket, network, nodes, edges) {
  let current_user_id = $('#current-user-id').val();

  // Now that you are connected, you can join channels with a topic:
  let ichannel = socket.channel("interactive:" + current_user_id, {});

  ichannel.on("interactive:network:initialize", (data) =>{
    nodes.clear();
    edges.clear();

    nodes.add(data['nodes']);
    // Add direction to edges
    let edges_data = data['edges'].map(
        function (el) {
          el['arrows'] = 'to';
          return el;
        });
    edges.add(edges_data);

    // Adjust a network zoom after draw nodes and edges
    network.fit();
  });

  ichannel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      });

  return ichannel;
}
