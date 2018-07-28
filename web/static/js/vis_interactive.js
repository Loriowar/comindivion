export default function initializeVisInteractive(vis, awesomplete) {
  // Node processing

  let nodeFormContainerSelector = '#editable-mind-object-container';
  let nodeInfoContainerSelector = '#readonly-mind-object-container';

  function fillNodeForm(data) {
    let $nodeForm = $(nodeFormContainerSelector);
    $nodeForm.find('#mind-object-title').val(data['title']);
    $nodeForm.find('#mind-object-content').val(data['content']);
    $nodeForm.find('#mind-object-uri').val(data['uri']);
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
            // NOTE: we can save a position only after successfully calling a network callback;
            //       if we update a record no needs to update a position, so, we make a different between create and
            //       update by looking on an existence or absence of `id` argument
            if(typeof network !== 'undefined' && id.length === 0) {
              saveNodePosition(node_data['id'], network);
            }
            hideNodeForm();
            clearNodeForm();

            let selected_nodes = network.getSelectedNodes();
            if (selected_nodes.length === 1 && selected_nodes[0] === id) {
              fetchAndShowNodeInfo(selected_nodes[0]);
            }
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
    $.get( "api/mind_objects/" + node_id)
        .done(function( data ) {
          fillNodeForm(data['mind_object']);
        })
        .fail(function(event){
          notifyUser();
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
        })
        .fail(function (event) {
          notifyUserByEvent(event, 'position');
        });
  }

    function saveNodePositions(node_ids, network) {
      let node_positions = network.getPositions(node_ids);
      let request_data = node_ids.map(node_id => {
        return [
          {name: 'mind_objects[' + node_id + '][x]', value: node_positions[node_id]['x']},
          {name: 'mind_objects[' + node_id + '][y]', value: node_positions[node_id]['y']},
        ]
      });
      // This is `flatten` method
      request_data = [].concat.apply([], request_data);
      $.ajax({
        type: "PATCH",
        url: "api/positions/",
        data: request_data})
          .done(function(ajax_data) {
            console.log('Positions saved');
          })
          .fail(function(event) {
            notifyUserByEvent(event, 'position');
          });
    }

  function centringAndSelectNode(network, node_id) {
    network.focus(node_id);
    network.selectNodes([node_id]);
    network.fit();
    fetchAndShowNodeInfo(node_id);
  }

  function centringAndSelectNodeByAnchor(network) {
    let anchor = window.location.hash;
    if(anchor.length > 0) {
      centringAndSelectNode(network, anchor.substring(1));
    }
  }

  function fetchAndShowNodeInfo(node_id) {
    $.get("api/mind_objects/" + node_id)
        .done(function(ajax_data) {
          let mind_object_data = ajax_data['mind_object'];
          let $nodeInfoContainer = $(nodeInfoContainerSelector);
          $nodeInfoContainer.find('.mind-object-title-value').text(mind_object_data['title']);
          $nodeInfoContainer.find('.mind-object-content-value').text(mind_object_data['content']);
          $nodeInfoContainer.find('.mind-object-uri-value > .text-part').text(mind_object_data['uri']);
          $nodeInfoContainer.find('.mind-object-uri-value > .href-part > a').attr("href", mind_object_data['uri']);
          if(!mind_object_data['uri']) {
            $nodeInfoContainer.find('.mind-object-uri-value > .href-part').hide();
          } else {
            $nodeInfoContainer.find('.mind-object-uri-value > .href-part').show();
          }
          $nodeInfoContainer.find('.mind-object-number-value').text(mind_object_data['number']);
          $nodeInfoContainer.find('.mind-object-date-value').text(mind_object_data['date']);
          $nodeInfoContainer.find('.mind-object-datetime-value').text(mind_object_data['datetime']);
          $nodeInfoContainer.find('.mind-object-group-value').text(mind_object_data['group']);
          showNodeInfo();
        })
        .fail(function(_event) {
          alert("Something goes wrong. Please, reload the page.");
        });
  }

  function deleteNode(node_id,  data = {}, callback = function(arg){}) {
    $.ajax({
      type: "DELETE",
      url: "api/mind_objects/" + node_id})
        .done(function(_ajax_data) {
          callback(data);
        })
        .fail(function(event) {
          notifyUserByEvent(event, 'mind_object');
          callback(null);
        });
  }

  function deleteNodes(node_ids,  data = {}, callback = function(arg){}) {
    $.ajax({
      type: "DELETE",
      url: "api/mind_objects/",
      data: {mind_object_ids: node_ids}})
        .done(function(_ajax_data) {
          callback(data);
        })
        .fail(function(event) {
          // TODO: implement displaying of errors after the mind object controller improvement
          notifyUser();
          callback(null);
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

  // Node group functions

  let nodeFormGroupContainerSelector = '#editable-mind-object-group-container';

  // TODO: encapsulate hide/show methods into submit/cancel callbacks
  function showNodeGroupForm() {
    $(nodeFormGroupContainerSelector).show();
  }

  function hideNodeGroupForm() {
    $(nodeFormGroupContainerSelector).hide();
  }

  function bindNodeGroupFormEvent(network, network_data) {
    let $nodeGroupForm = $(nodeFormGroupContainerSelector).first('form');
    $nodeGroupForm.submit(function(event) {
      let group_value = $('#mind-object-group-name').val();
      let node_ids = network.getSelectedNodes();
      $.ajax({
        type: "PATCH",
        url: "api/groups/",
        data: {
          group: group_value,
          mind_object_ids: node_ids
        }
      })
          .done(function(_ajax_data) {
            //TODO: wrap all cancel actions within a single method
            hideNodeGroupForm();
            clearNodeGroupForm();
            $.each(node_ids, function(index, node_id) {
              network_data['nodes'].update({id: node_id, group: group_value});
            });
          })
          .fail(function(_event) {
            hideNodeGroupForm();
            clearNodeGroupForm();
            notifyUser();
          });

      event.stopPropagation();
      event.preventDefault();
      return false;
    });

    $nodeGroupForm.find('#mind-object-group-cancel').first().click(function(data) {
      hideNodeGroupForm();
      clearNodeGroupForm();
      return false;
    })
  }

  function fillNodeGroupForm(group_name) {
    $(nodeFormGroupContainerSelector).find('#mind-object-group-name').val(group_name);
  }

  function fetchAndFillNodeGroupForm(network, network_data) {
    let groups = [];
    $.each(network.getSelectedNodes(), function( index, node_id) {
      groups.push(network_data['nodes'].get(node_id)['group']);
    });
    let uniq_groups = groups.filter(function(value, index, self) {return self.indexOf(value) === index});
    if(uniq_groups.length === 1) {
      fillNodeGroupForm(uniq_groups[0]);
    }
  }

  function clearNodeGroupForm() {
    $(nodeFormGroupContainerSelector).find('#mind-object-group-name').val('');
  }

  function initNodeGroupAwesompleteInput() {
    let group_input = $(nodeFormGroupContainerSelector).find('#mind-object-group-name')[0];
    let awesomplete_node_group_input = new awesomplete(group_input, {minChars: 0});
    awesomplete_node_group_input.list = ["Dummy"];
    return awesomplete_node_group_input;
  }

  function fetchAndFillNodeGroupInput(awesomplete_input) {
    $.get("api/groups")
        .done(function(ajax_data) {
          let groups = ajax_data['groups'];
          if(Array.isArray(groups)) {
            awesomplete_input.list = groups;
          }
        })
        .fail(function(_event) {
          notifyUser('Unagle to load list of nodes groups.');
        });
  }

  // Search functions

  function searchByNodeName(network, name) {
    $.get("api/search", {q: name})
        .done(function(ajax_data) {
          let nodes = ajax_data['nodes'];
          if(nodes.length > 0) {
            centringAndSelectNode(network, nodes[0].id);
            drawSearchResult(nodes);
          } else {
            // TODO: remove after implement a displaying of a search result
            alert('Found nothing. Try to find something else.');
          }
        })
        .fail(function(_event) {
          alert("Something goes wrong. Please, try again or reload the page.");
        });
  }

  function clearSearchResult() {
    let $searchResultContainer = $('#search-container').find('.search-result-container').first();
    $searchResultContainer.children('.search-result-row').remove();
  }

  function drawSearchResult(nodes) {
    let $searchContainer = $('#search-container');
    let $searchResultContainer = $searchContainer.find('.search-result-container').first();
    let $searchResultRowTemplate = $searchContainer.find('#search-result-row-template').first();
    $.each(nodes, function( index, node) {
      let new_result_row = document.importNode($searchResultRowTemplate[0].content, true);
      new_result_row.querySelectorAll('.search-result-title')[0].textContent = node['title'];
      new_result_row.querySelectorAll('.link-to-locate-node-on-network')[0].setAttribute('data-node-id', node['id']);
      $searchResultContainer[0].appendChild(new_result_row);
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

  // Additional events for Network

  // Prototype from https://github.com/almende/vis/issues/977
  const initMultiSelectByRectangleArea = (container, network, nodes) => {
    const NO_CLICK = 0;
    const RIGHT_CLICK = 3;

    // Disable default right-click dropdown menu
    container[0].oncontextmenu = () => false;

    // State

    let drag = false, DOMRect = {};

    // Selector

    const canvasify = (DOMx, DOMy) => {
      const { x, y } = network.DOMtoCanvas({ x: DOMx, y: DOMy });
      return [x, y];
    };

    const correctRange = (start, end) =>
        start < end ? [start, end] : [end, start];

    const selectFromDOMRect = () => {
      const [sX, sY] = canvasify(DOMRect.startX, DOMRect.startY);
      const [eX, eY] = canvasify(DOMRect.endX, DOMRect.endY);
      const [startX, endX] = correctRange(sX, eX);
      const [startY, endY] = correctRange(sY, eY);

      network.selectNodes(nodes.get().reduce(
          (selected, { id }) => {
            const { x, y } = network.getPositions(id)[id];
            return (startX <= x && x <= endX && startY <= y && y <= endY) ?
                selected.concat(id) : selected;
          }, []
      ));

      // Dirty hack. In an ideal world, needs to fire the `selectNode` event from `selectNodes(...)`, but  there is no
      // any triggering of events. So, we manually process required actions through calling of private methods of
      // the network.
      if($('.vis-manipulation').find('.vis-delete').length === 0 && network.getSelectedNodes().length > 0) {
        network.manipulation._createSeperator();
        // TODO: remember about hardcode of a locale
        network.manipulation._createDeleteButton('en');
      }
    };

    // Listeners

    container.on("mousedown", function({ which, pageX, pageY }) {
      // When mousedown, save the initial rectangle state
      if(which === RIGHT_CLICK) {
        Object.assign(DOMRect, {
          startX: pageX - this.offsetLeft,
          startY: pageY - this.offsetTop,
          endX: pageX - this.offsetLeft,
          endY: pageY - this.offsetTop
        });
        drag = true;
      }
    });

    container.on("mousemove", function({ which, pageX, pageY }) {
      // Make selection rectangle disappear when accidently mouseupped outside 'container'
      if(which === NO_CLICK && drag) {
        drag = false;
        network.redraw();
      }
      // When mousemove, update the rectangle state
      else if(drag) {
        Object.assign(DOMRect, {
          endX: pageX - this.offsetLeft,
          endY: pageY - this.offsetTop
        });
        network.redraw();
      }
    });

    container.on("mouseup", function({ which }) {
      // When mouseup, select the nodes in the rectangle
      if(which === RIGHT_CLICK) {
        drag = false;
        network.redraw();
        selectFromDOMRect();
      }
    });

    // Drawer

    network.on('afterDrawing', ctx => {
      if(drag) {
        const [startX, startY] = canvasify(DOMRect.startX, DOMRect.startY);
        const [endX, endY] = canvasify(DOMRect.endX, DOMRect.endY);

        ctx.setLineDash([5]);
        ctx.strokeStyle = 'rgba(78, 146, 237, 0.75)';
        ctx.strokeRect(startX, startY, endX - startX, endY - startY);
        ctx.setLineDash([]);
        ctx.fillStyle = 'rgba(151, 194, 252, 0.45)';
        ctx.fillRect(startX, startY, endX - startX, endY - startY);
      }
    });
  };

  // Network initialization

  let container = document.getElementById('interactive');

  if(container !== null) {
    $.get( "api/i", function( data ) {
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
          },
          smooth: {
            enabled: false
          },
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
          hover: true,
          multiselect: true
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
            bindNodeFormEvents(data, callback, data['id'], network);
            showNodeForm();
          },
          deleteNode: function (data, callback) {
            deleteNodes(data['nodes'], data, callback);
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

      // NOTE: setOptions doesn't set a shape of nodes (experimental fact)
      network.setOptions($.extend(initial_options, additional_options));
      network.redraw();

      initMultiSelectByRectangleArea($(container), network, network_data['nodes']);

      network.on("selectNode", function (params) {
        if(params['nodes'].length === 1) {
          let node_id = params['nodes'][0];
          fetchAndShowNodeInfo(node_id);
        }
      });

      network.on("deselectNode", function (_params) {
        hideNodeInfo();
      });

      network.on("dragEnd", function (params) {
        if(params['nodes'].length > 0) {
          saveNodePositions(params['nodes'], network);
        }
      });

      // Select node with id from anchor
      centringAndSelectNodeByAnchor(network);
      // Add event on anchor change
      if ("onhashchange" in window) { // old browsers doesn't support this event
        window.onhashchange = function () {
          centringAndSelectNodeByAnchor(network);
        }
      }

      // Initialize search form

      let $searchForm = $('#search-form');
      $searchForm.submit(function(event) {
        let form_data_hash = {};
        let form_data_array = $(event.target).serializeArray();
        $(form_data_array).each(function(i, field){
          form_data_hash[field.name] = field.value;
        });

        clearSearchResult();
        searchByNodeName(network, form_data_hash['q']);
        return false;
      });

      $('.search-result-container').on('click', '.link-to-locate-node-on-network', function(event) {
        let node_id = event.target.dataset.nodeId;
        centringAndSelectNode(network, node_id);
        fetchAndShowNodeInfo(node_id);
      });

      // Additional network manipulation actions

      let MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
      let list = document.querySelector('.vis-manipulation');

      let observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
          if(mutation.type === 'childList' && mutation.addedNodes.length === 1 && network.getSelectedNodes().length > 0) {
            if(mutation.addedNodes[0].classList.contains('vis-delete')) {
              $('<div class="vis-button vis-edit vis-edit-group" style="touch-action: pan-y; -moz-user-select: none;"><div class="vis-label">Edit Group</div></div><div class="vis-separator-line"></div>').insertBefore($('.vis-manipulation').find('.vis-button.vis-delete'));
            }
          }
        });
      });

      observer.observe(list, {childList: true});

      let awesomplete_node_group_input = initNodeGroupAwesompleteInput();

      $('.vis-manipulation').on('click', '.vis-edit-group', function(event) {
        fetchAndFillNodeGroupForm(network, network_data);
        fetchAndFillNodeGroupInput(awesomplete_node_group_input);
        showNodeGroupForm();
      });

      bindNodeGroupFormEvent(network, network_data);
    });
  }
}
