export default function initializeVisInteractive(vis) {
  let formContainerSelector = '#editable-mind-object';

  function fillNodeForm(data) {
    let $nodeForm = $(formContainerSelector);
    $nodeForm.find('#mind-object-title').val(data['title']);
    $nodeForm.find('#mind-object-content').val(data['content']);
  }

  function clearNodeForm() {
    fillNodeForm({title: '', content: ''});
    let $nodeForm = $(formContainerSelector).first('#editable-mind-object');
    $nodeForm.off('submit');
    $nodeForm.first('#mind-object-cancel').off('click');
  }

  // TODO: encapsulate hide/show methods into submit/cancel callbacks
  function showNodeForm() {
    $(formContainerSelector).show();
  }

  function hideNodeForm() {
    $(formContainerSelector).hide();
  }

  // TODO: add separate callbacks for submit and cancel with passing and internal processing of 'callback'
  function bindNodeFormEvents(node_data, callback = function(arg){}, id = '') {
    let $nodeForm = $(formContainerSelector).first('form');
    $nodeForm.submit(function(event) {
      $.post("api/mind_objects/" + id, $(event.target).serialize())
          .done(function(ajax_data) {
            node_data['id'] = ajax_data['mind_object']['id'];
            node_data['label'] = ajax_data['mind_object']['title'];

            callback(node_data);
            hideNodeForm();
            clearNodeForm();
          })
          .fail(function(event) {
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
    let $nodeForm = $(formContainerSelector).first('#editable-mind-object');
    $.get( "api/mind_objects/" + node_id, function( data ) {
      fillNodeForm(data['mind_object']);
    });
  }

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
          randomSeed: 7
        },
        interaction: {
          hover:true
        },
        manipulation: {
          enabled: true,
          addNode: function (data, callback) {
            clearNodeForm();
            bindNodeFormEvents(data, callback);
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
                  callback(null);
            });
          }
        }
      };

      let network = new vis.Network(container, network_data, options);

      network.on("selectNode", function (params) {
        let node_id = params['nodes'][0];
        // TODO: implement separate readonly form for show node information
      });

      network.on("deselectNode", function (params) {
        // TODO: implement separate readonly form for show node information
      });
    });
  }
}
