var ws = new WebSocket(location.href.replace(/^http/, 'ws'));

/* get a proper attr */
var getAttribute = function(i, node) {
    var attr = null;
    if ( i == 'updated_at' ) {
        attr = dateFormat(node[i], "yyyy-mm-dd' 'HH:MM:ss' 'o");
    } else {
        attr = node[i];
    }
    return attr;
}

/* update the screen when node status changed */
var animateUpdate = function(node) {
    // add a node
    if ( node.hasOwnProperty('device_mac') ) {
        $("#nodeTable > tbody")
            .append($('<tr id="device-' + node["id"] + '">'));
        var tr = $('#nodeTable > tbody > tr:last');
        for (var i in node) {
            var attr = getAttribute(i, node);
            tr.append($('<td>').addClass('animated '+i).html(attr));
        }
        tr.append($('<td>').addClass('animated status').html('N/A'));
    }

    // update the node attr
    for (var i in node) {
      if ( i == 'id' ) {
        var id = node[i];
      } else {
        var attr = getAttribute(i, node);
        var prop = $("#device-" + id + " td." + i);
        prop.addClass('fadeOut');
        prop.html(attr);
        prop.addClass('fadeIn');
        prop.removeClass('fadeOut fadeIn');
      }
    }

    // update the node status
    if ( node.hasOwnProperty('status') ) {
        if (node['status'] == 'down') {
            var prop = $("#device-" + node['id'] + " td.status");
            prop.addClass('fadeOut down');
            prop.html('down');
            prop.addClass('fadeIn');
            prop.removeClass('fadeOut active fadeIn');
        }
    } else {
            var prop = $("#device-" + node['id'] + " td.status");
            prop.addClass('fadeOut active');
            prop.html('active');
            prop.addClass('fadeIn');
            prop.removeClass('fadeOut down fadeIn');
    }
};

$(document).ready(function(e) {
    ws.onopen = function() {
        console.log(ws);
    }

    ws.onmessage = function(msg) {
        var data = JSON.parse(msg.data);
        if( data.topic == 'node' ) {
            animateUpdate(data.node);
        }
    }

    ws.onclose = function() {
        console.log(ws);
        location.reload()
    }
});

