export default function initializeVisInteractive(vis) {
  // Node processing

  let nodeFormContainerSelector = '#editable-mind-object';

  function fillNodeForm(data) {
    let $nodeForm = $(nodeFormContainerSelector);
    $nodeForm.find('#mind-object-title').val(data['title']);
    $nodeForm.find('#mind-object-content').val(data['content']);
  }

  function clearNodeForm() {
    fillNodeForm({title: '', content: ''});
    let $nodeForm = $(nodeFormContainerSelector);
    $nodeForm.off('submit');
    $nodeForm.find('#mind-object-cancel').first().off('click');
  }

  // TODO: encapsulate hide/show methods into submit/cancel callbacks
  function showNodeForm() {
    $(nodeFormContainerSelector).show();
  }

  function hideNodeForm() {
    $(nodeFormContainerSelector).hide();
  }

  // TODO: add separate callbacks for submit and cancel with passing and internal processing of 'callback'
  function bindNodeFormEvents(node_data, callback = function(arg){}, id = '', network) {
    let $nodeForm = $(nodeFormContainerSelector).first('form');
    $nodeForm.submit(function(event) {
      let form_data = $(event.target).serializeArray();
      $.post("api/mind_objects/" + id, form_data)
          .done(function(ajax_data) {
            node_data['id'] = ajax_data['mind_object']['id'];
            node_data['label'] = ajax_data['mind_object']['title'];

            callback(node_data);
            if(typeof network !== 'undefined') {
              saveNodePosition(node_data['id'], network);
            }
            hideNodeForm();
            clearNodeForm();
          })
          .fail(function(event) {
            alert("Something goes wrong. Please, reload the page.");
            callback(null);
            hideNodeForm();
            clearNodeForm();
        });
      event.stopPropagation();
      event.preventDefault();
      return false;
    });
    // TODO: strange jQuery hack, fix this
    $nodeForm.find('#mind-object-cancel').first().click(function(data) {
      callback(null);
      hideNodeForm();
      clearNodeForm();
    })
  }

  function fetchAndFillNodeForm(node_id) {
    $.get( "api/mind_objects/" + node_id, function( data ) {
      fillNodeForm(data['mind_object']);
    });
  }

  function saveNodePosition(node_id, network) {
    let node_position = network.getPositions()[node_id];
    let position_data = [
      {name: 'position[x]', value: node_position['x']},
      {name: 'position[y]', value: node_position['y']},
    ];
    $.post("api/positions/" + node_id, position_data)
        .done(function (ajax_data) {
          console.log('Position saved');
          console.log(ajax_data);
        })
        .fail(function (_event) {
          alert("Something goes wrong. Please, reload the page.");
        });
  }

  // Edge processing

  let edgeFormContainerSelector = '#editable-relation';

  // TODO: encapsulate hide/show methods into submit/cancel callbacks
  function showEdgeForm() {
    $(edgeFormContainerSelector).show();
  }

  function hideEdgeForm() {
    $(edgeFormContainerSelector).hide();
  }

  function clearEdgeForm() {
    let $nodeForm = $(edgeFormContainerSelector);
    $nodeForm.off('submit');
    $nodeForm.find('#subject-object-relation-cancel').first().off('click');
  }

  // TODO: add separate callbacks for submit and cancel with passing and internal processing of 'callback'
  function bindEdgeFormEvents(edge_data, callback = function(arg){}, id = '') {
    let $edgeForm = $(edgeFormContainerSelector).first('form');
    $edgeForm.submit(function(event) {
      let form_data = $(event.target).serializeArray();
      form_data.push({name: 'subject_object_relation[subject_id]', value: edge_data['from']});
      form_data.push({name: 'subject_object_relation[object_id]', value: edge_data['to']});
      $.post("api/subject_object_relations/" + id, form_data)
          .done(function(ajax_data) {
            edge_data['id'] = ajax_data['subject_object_relation']['id'];
            edge_data['label'] = ajax_data['subject_object_relation']['name'];

            callback(edge_data);

            hideEdgeForm();
            clearEdgeForm();
          })
          .fail(function(_event) {
            alert("Something goes wrong. Please, reload the page.");
            callback(null);
            hideEdgeForm();
            clearEdgeForm();
          });

      event.stopPropagation();
      event.preventDefault();
      return false;
    });

    // TODO: strange jQuery hack, fix this
    $edgeForm.find('#subject-object-relation-cancel').first().click(function(data) {
      callback(null);
      hideEdgeForm();
      clearEdgeForm();
    })
  }

  // Network initialization

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

      let network = new vis.Network(container, network_data);

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
          margin: 12,
          widthConstraint: {
            maximum: 200
          }
        },
        physics: {
          enabled: false
        },
        interaction: {
          hover:true
        },
        manipulation: {
          enabled: true,
          addNode: function (data, callback) {
            clearNodeForm();
            bindNodeFormEvents(data, callback, '', network);
            showNodeForm();
          },
          editNode: function (data, callback) {
            clearNodeForm();
            fetchAndFillNodeForm(data['id']);
            bindNodeFormEvents(data, callback, data['id']);
            showNodeForm();
          },
          deleteNode: function (data, callback) {
            $.ajax({
              type: "DELETE",
              url: "api/mind_objects/" + data['nodes'][0]})
                .done(function(_ajax_data) {
                  callback(data);
                })
                .fail(function(_event) {
                  alert("Something goes wrong. Please, reload the page.");
                  callback(null);
            });
          },
          addEdge: function (data, callback) {
            // Add direction to new edge
            data['arrows'] = 'to';

            clearEdgeForm();
            bindEdgeFormEvents(data, callback, '');
            showEdgeForm();
          },
          deleteEdge: function (data, callback) {
            $.ajax({
              type: "DELETE",
              url: "api/subject_object_relations/" + data['edges'][0]})
                .done(function(_ajax_data) {
                  callback(data);
                })
                .fail(function(_event) {
                  alert("Something goes wrong. Please, reload the page.");
                  callback(null);
                });
          },
        }
      };

      network.setOptions(options);

      network.on("selectNode", function (params) {
        let node_id = params['nodes'][0];
        // TODO: implement separate readonly form for show node information
      });

      network.on("deselectNode", function (params) {
        // TODO: implement separate readonly form for show node information
      });
      network.on("dragEnd", function (params) {
        if(params['nodes'].length > 0) {
          saveNodePosition(params['nodes'][0], network);
        }
      });
    });
  }
}
