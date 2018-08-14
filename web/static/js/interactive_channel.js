export default function initializeInteractiveChannel(socket, network, nodes, edges) {
  let current_user_id = $('#current-user-id').val();

  function positionDataToNetworkFormat(data) {
    let node_data = {
      id: data["position"]["mind_object_id"],
      x: data["position"]["x"],
      y: data["position"]["y"]
    };

    // Network badly handle a group with `null` value
    if(!!data["position"]["group"]) {
      node_data["group"] = data["position"]["group"];
    }

    return node_data;
  }

  function mindObjectDataToNetworkFormat(data) {
    return {
      id: data["mind_object"]["id"],
      label: data["mind_object"]["title"]
    }
  }

  function updateNodePosition(data, nodes) {
    if(!!nodes.get(data["position"]["mind_object_id"])) {
      let node_data = positionDataToNetworkFormat(data);
      nodes.update(node_data);
    }
  }

  function deleteNode(node_id, nodes) {
    if(!!nodes.get(node_id)) {
      nodes.remove(node_id);
    }
  }

  function edgeDataToNetworkFormat(data) {
    return {
      id: data["subject_object_relation"]["id"],
      label: data["subject_object_relation"]["name"],
      from: data["subject_object_relation"]["subject_id"],
      to: data["subject_object_relation"]["object_id"],
      arrows: "to"
    };
  }

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
      let node_data = mindObjectDataToNetworkFormat(data);
      nodes.add(node_data);
    }
  });

  ichannel.on("interactive:network:node:update", (data) =>{
    console.log('Node update message');
    if(!!nodes.get(data["mind_object"]["id"])) {
      let node_data = mindObjectDataToNetworkFormat(data);
      nodes.update(node_data);
    }
  });

  ichannel.on("interactive:network:node:delete", (data) =>{
    console.log('Node delete message');
    deleteNode(data["mind_object"]["id"], nodes);
  });

  ichannel.on("interactive:network:nodes:delete", (data) =>{
    console.log('Nodes delete message');
    $.each(data["mind_objects"], function( index, value ) {
      deleteNode(value["mind_object"]["id"], nodes);
    });
  });

  ichannel.on("interactive:network:node_position:update", (data) =>{
    console.log('Node position update message');
    updateNodePosition(data, nodes);
  });

  ichannel.on("interactive:network:node_positions:update", (data) =>{
    console.log('Node positions update message');
    $.each(data["positions"], function( index, value ) {
      updateNodePosition(value, nodes);
    });
  });

  ichannel.on("interactive:network:edge:create", (data) =>{
    console.log('Edge create message');
    if(!edges.get(data["subject_object_relation"]["id"])) {
      let edge_data = edgeDataToNetworkFormat(data);
      edges.add(edge_data);
    }
  });

  ichannel.on("interactive:network:edge:update", (data) =>{
    console.log('Edge update message');
    if(!!edges.get(data["subject_object_relation"]["id"])) {
      let edge_data = edgeDataToNetworkFormat(data);
      edges.update(edge_data);
    }
  });

  ichannel.on("interactive:network:edge:delete", (data) =>{
    console.log('Edge delete message');
    let edge_id = data["subject_object_relation"]["id"];
    if(!!edges.get(edge_id)) {
      edges.remove(edge_id);
    }
  });

  ichannel.on("interactive:network:node_groups:update", (data) =>{
    console.log('Node groups update message');
    $.each(data["positions"], function( index, value ) {
      updateNodePosition(value, nodes);
    });
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
