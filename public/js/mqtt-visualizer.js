var ws = new WebSocket(location.href.replace(/^http/, 'ws'));

/* Update the screen when node status changed */
var animateUpdate = function(id, nodeStatus) {
};

$(document).ready(function(e) {
    ws.onopen = function() {
        console.log(ws);
    }

    ws.onmessage = function(msg) {
        var data = JSON.parse(msg.data);
        animateUpdate(data.id, data.nodeStatus);
    }

    ws.onclose = function() {
        console.log(ws);
        location.reload()
    }
});

