export default function initializeInteractiveChannel(socket, network, nodes, edges) {
  let current_user_id = $('#current-user-id').val();

  // Now that you are connected, you can join channels with a topic:
  let ichannel = socket.channel("interactive:" + current_user_id, {});

  // This is a worked network initializer, but for now, preferable to use REST-API
  // ichannel.on("interactive:network:initialize", (data) =>{
  //   nodes.clear();
  //   edges.clear();
  //
  //   nodes.add(data['nodes']);
  //   // Add direction to edges
  //   let edges_data = data['edges'].map(
  //       function (el) {
  //         el['arrows'] = 'to';
  //         return el;
  //       });
  //   edges.add(edges_data);
  //
  //   // Adjust a network zoom after draw nodes and edges
  //   network.fit();
  // });

  ichannel.on("interactive:network:node:create", (data) =>{
    console.log('Node create message');
    if(!nodes.get(data["mind_object"]["id"])) {
      let node_data =
          {
            id: data["mind_object"]["id"],
            label: data["mind_object"]["title"]
          };
      nodes.add(node_data);
    }
  });

  ichannel.on("interactive:network:node_position:update", (data) =>{
    console.log('Node position update message');
    if(nodes.get(data["position"]["mind_object_id"])) {
      console.log(data);
      let node_data =
          {
            id: data["position"]["mind_object_id"],
            x: data["position"]["x"],
            y: data["position"]["y"],
            group: data["position"]["group"]
          };
      console.log(node_data);
      nodes.update(node_data);
    }
  });

  // ichannel.on("interactive:network:node_positions:update", (data) =>{
  //   nodes.update(data);
  // });
  //
  // ichannel.on("interactive:network:nodes:update", (data) =>{
  //   nodes.update(data);
  // });
  //
  // ichannel.on("interactive:network:nodes:delete", (data) =>{
  //   nodes.remove(data);
  // });

  ichannel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      });

  return ichannel;
}
