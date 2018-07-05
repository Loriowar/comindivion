export default function initializeVisInteractive(vis) {
  // Node processing

  let nodeFormContainerSelector = '#editable-mind-object-container';
  let nodeInfoContainerSelector = '#readonly-mind-object-container';

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
  function showNodeInfo() {
    $(nodeInfoContainerSelector).show();
  }

  function hideNodeInfo() {
    $(nodeInfoContainerSelector).hide();
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
            // NOTE: we can save a position only after successfully calling a network callback
            if(typeof network !== 'undefined') {
              saveNodePosition(node_data['id'], network);
            }
            hideNodeForm();
            clearNodeForm();
          })
          .fail(function(event) {
            notifyUserByEvent(event, 'mind_object');
            callback(null);
            hideNodeForm();
            clearNodeForm();
        });
      event.stopPropagation();
      event.preventDefault();
      return false;
    });
    // TODO: strange jQuery hack with `first` method, fix this
    $nodeForm.find('#mind-object-cancel').first().click(function(data) {
      callback(null);
      hideNodeForm();
      clearNodeForm();
      return false;
    })
  }

  function fetchAndFillNodeForm(node_id) {
    $.get( "api/mind_objects/" + node_id, function( data ) {
      fillNodeForm(data['mind_object']);
    });
  }

  function saveNodePosition(node_id, network) {
    let node_position = network.getPositions(node_id)[node_id];
    let position_data = [
      {name: 'position[x]', value: node_position['x']},
      {name: 'position[y]', value: node_position['y']},
    ];
    $.post("api/positions/" + node_id, position_data)
        .done(function (ajax_data) {
          console.log('Position saved');
          console.log(ajax_data);
        })
        .fail(function (event) {
          notifyUserByEvent(event, 'position');
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
            edge_data['from'] = ajax_data['subject_object_relation']['subject_id'];
            edge_data['to'] = ajax_data['subject_object_relation']['object_id'];
            // NOTE: hack from vis.js manipulationEditEdgeNoDrag example
            // if (typeof edge_data.to === 'object')
            //   edge_data.to = edge_data.to.id;
            // if (typeof edge_data.from === 'object')
            //   edge_data.from = edge_data.from.id;

            callback(edge_data);

            hideEdgeForm();
            clearEdgeForm();
          })
          .fail(function(event) {
            notifyUserByEvent(event, 'subject_object_relation');
            callback(null);
            hideEdgeForm();
            clearEdgeForm();
          });

      event.stopPropagation();
      event.preventDefault();
      return false;
    });

    // TODO: strange jQuery hack with `first` method, fix this
    $edgeForm.find('#subject-object-relation-cancel').first().click(function(data) {
      callback(null);
      hideEdgeForm();
      clearEdgeForm();
      return false;
    })
  }

  function fillEdgeForm(label) {
    let $edgeForm = $(edgeFormContainerSelector);
    let predicate_id = $edgeForm.find('option:contains("' + label + '")').first().val();
    $edgeForm.find('#subject_object_relation_predicate_id').first().val(predicate_id).trigger('change.select2');
  }

  // Search functions

  function searchByNodeName(network, name) {
    $.get("api/search", {q: name})
        .done(function(ajax_data) {
          let nodes = ajax_data['nodes'];
          if(nodes.length > 0) {
            network.focus(nodes[0].id);
            network.selectNodes([nodes[0].id]);
          } else {
            // TODO: remove after implement a displaying of a search result
            alert('Found nothing. Try to find something else.');
          }
        })
        .fail(function(_event) {
          alert("Something goes wrong. Please, try again or reload the page.");
        });
  }

  // Global functions

  function notifyUser(message = '') {
    let prepared_message = "Something goes wrong.";
    if(!message) {
      prepared_message += " Please, reload the page.";
    } else {
      prepared_message += " Reason: '" + message + "'";
    }
    alert(prepared_message);
  }

  function errorsToMessage(errors) {
    let message = '';
    $.each( errors, function(k, v){
      message += k + ' ' + v;
    });
    return message;
  }

  function eventToErrors(event, object_name) {
    let errors = {};
    // NOTE: Dirty analog of Ruby `dig` method
    try {
      errors = event['responseJSON'][object_name]['errors'];
    } catch (err) {
      // Do nothing
    }
    return errors;
  }

  function notifyUserByEvent(event, object_name) {
    notifyUser(errorsToMessage(eventToErrors(event, object_name)));
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

      // Initial options required for apply nodes shape during initialization, otherwise for rendered nodes
      // there shape setted in setOptions will be ignored
      let initial_options = {
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
          hover: true
        }
      };

      // We must initialize network for using it within callbacks
      let network = new vis.Network(container, network_data, initial_options);

      let additional_options = {
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
                .fail(function(event) {
                  notifyUserByEvent(event, 'mind_object');
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
          editEdge: {
            editWithoutDrag: function (data, callback) {
              clearEdgeForm();
              fillEdgeForm(data['label']);
              bindEdgeFormEvents(data, callback, data['id']);
              showEdgeForm();
            }
          },
          deleteEdge: function (data, callback) {
            $.ajax({
              type: "DELETE",
              url: "api/subject_object_relations/" + data['edges'][0]})
                .done(function(_ajax_data) {
                  callback(data);
                })
                .fail(function(event) {
                  notifyUserByEvent(event, 'subject_object_relation');
                  callback(null);
                });
          },
        }
      };

      // NOTE: setOptions doesn't set a nodes shape (experimental fact)
      network.setOptions($.extend(initial_options, additional_options));
      network.redraw();

      network.on("selectNode", function (params) {
        let node_id = params['nodes'][0];
        $.get("api/mind_objects/" + node_id)
            .done(function(ajax_data) {
              let mind_object_data = ajax_data['mind_object'];
              let $nodeInfoContainer = $(nodeInfoContainerSelector);
              $nodeInfoContainer.find('.mind-object-title-value').text(mind_object_data['title']);
              $nodeInfoContainer.find('.mind-object-content-value').text(mind_object_data['content']);
              $nodeInfoContainer.find('.mind-object-uri-value').text(mind_object_data['uri']);
              $nodeInfoContainer.find('.mind-object-number-value').text(mind_object_data['number']);
              $nodeInfoContainer.find('.mind-object-date-value').text(mind_object_data['date']);
              $nodeInfoContainer.find('.mind-object-datetime-value').text(mind_object_data['datetime']);
              showNodeInfo();
            })
            .fail(function(_event) {
              alert("Something goes wrong. Please, reload the page.");
            });
      });

      network.on("deselectNode", function (params) {
        hideNodeInfo();
      });
      network.on("dragEnd", function (params) {
        if(params['nodes'].length > 0) {
          saveNodePosition(params['nodes'][0], network);
        }
      });

      let $searchForm = $('#search-form');
      $searchForm.submit(function(event) {
        let form_data_hash = {};
        let form_data_array = $(event.target).serializeArray();
        $(form_data_array).each(function(i, field){
          form_data_hash[field.name] = field.value;
        });

        searchByNodeName(network, form_data_hash['q']);
        return false;
      })
    });
  }
}
