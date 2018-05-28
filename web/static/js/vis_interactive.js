export default function initializeVisInteractive(vis) {
  let formContainerSelector = '#editable-mind-object';

  function fillNodeForm(data) {
    let $nodeForm = $(formContainerSelector).first('#editable-mind-object');
    $nodeForm.first('#mind-object-title').val(data['title']);
    $nodeForm.first('#mind-object-content').val(data['content']);
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
  function bindNodeFormEvents(node_data, callback) {
    let $nodeForm = $(formContainerSelector).first('form');
    $nodeForm.submit(function(event) {
      $.post("api/mind_objects", $(event.target).serialize())
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
    let $nodeForm = $(form_container_selector).first('#editable-mind-object');
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
          }
        }
      };

      let network = new vis.Network(container, network_data, options);
    });
  }
}
