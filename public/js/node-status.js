var ws = new WebSocket(location.href.replace(/^http/, "ws"));

/* get a proper attr */
var getAttribute = function(i, node) {
    var attr = null;
    if (i == "updated_at") {
        attr = dateFormat(node[i], "yyyy-mm-dd' 'HH:MM:ss' 'o");
    } else {
        attr = node[i];
    }
    return attr;
};

var changeNodeStatus = function(id, nodeStatus) {
    var prop = $("#device-" + id + " td.status");
    if( prop.html() != nodeStatus ) {
        prop.html(nodeStatus);
        prop.removeClass().addClass("status " + nodeStatus);
    }
    var prop = $("#device-" + id + " td.sensor_mac a");
    if( nodeStatus == "active" ) {
        prop.removeClass("not-active");
    } else {
        prop.addClass("not-active");
    }
};

/* update the screen when node status changed */
var animateUpdate = function(node) {
    // add a node
    /* check if specified id exist in the table instead of getting device_mac
    if (node.hasOwnProperty("device_mac")) {
        $("#nodeTable > tbody").append($('<tr id="device-' + node["id"] + '">'));
        var tr = $("#nodeTable > tbody > tr:last");
        for (var i in node) {
            var attr = getAttribute(i, node);
            tr.append($("<td>").addClass("animated " + i).html(attr));
        }
        tr.append($("<td>").addClass("animated status").html("N/A"));
    }
    */
    // update the node status and info
    if (node.hasOwnProperty("status")) {
        switch (node["status"]) {
          case "down":
            changeNodeStatus(node["id"], "down");
            break;
          case "pending":
            changeNodeStatus(node["id"], "pending");
            break;
          case "initialized":
            changeNodeStatus(node["id"], "initialized");
            break;
        }
    } else if (node.hasOwnProperty("device_mac")) {
        // update the node attr
        for (var i in node) {
            if (i == "id") {
                var id = node[i];
            } else {
                var attr = getAttribute(i, node);
                var prop = $("#device-" + id + " td." + i);
                if (prop.html() != attr) {
                    prop.addClass("fadeOut");
                    if (i == "sensor_mac") {
                        var mac = attr.replace(/:/g, "").toLowerCase();
                        prop.children().html(attr);
                        prop.children().attr("href", "https://quickstart.internetofthings.ibmcloud.com/#/device/" + mac + "/sensor/");
                    } else {
                        prop.html(attr);
                    }
                    prop.addClass("fadeIn");
                    prop.removeClass("fadeOut fadeIn");
                }
            }
        }
    } else {
        changeNodeStatus(node["id"], "active");
    }
};

$(document).ready(function(e) {
    ws.onopen = function() {
        console.log(ws);
    };
    ws.onmessage = function(msg) {
        var data = JSON.parse(msg.data);
        if (data.topic == "node") {
            console.log(data.node);
            animateUpdate(data.node);
        }
    };
    ws.onclose = function() {
        console.log(ws);
        location.reload();
    };
});
