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
    if (prop.html() != nodeStatus) {
        prop.html(nodeStatus);
        prop.removeClass().addClass("status " + nodeStatus);
    }
    var prop = $("#device-" + id + " td.sensor_mac a");
    if (nodeStatus == "active") {
        prop.removeClass("not-active");
    } else {
        prop.addClass("not-active");
    }
};

/* update the screen when node status changed */
var animateUpdate = function(node) {
    /* add a node by checking specified id exist in the table */
    if (!$("#device-" + node["id"]).length) {
        $("#nodeTable > tbody").append($('<tr id="device-' + node["id"] + '">'));
        var tr = $("#nodeTable > tbody > tr:last");
        var attrs = [ "device_mac", "sensor_mac", "ip", "updated_at", "status" ];
        for (var i in attrs) {
            var attr = attrs[i];
            tr.append($("<td>").addClass("animated " + i).html(""));
        }
    }
    /* update the node status and info => switch case for clarification */
    if (node.hasOwnProperty("status")) {
        switch (node["status"]) {
          case "down":
            changeNodeStatus(node["id"], node["status"]);
            break;

          case "discovering":
            changeNodeStatus(node["id"], node["status"]);
            break;

          case "initialized":
            changeNodeStatus(node["id"], node["status"]);
            break;

          case "initializing":
            changeNodeStatus(node["id"], node["status"]);
            break;

          case "active":
            changeNodeStatus(node["id"], node["status"]);
            break;
        }
    } 
    /* update the rest of node info attr */
    console.log(node);
    var id = node["id"];
    for (var i in node) {
        if (i == "id") continue;
        var attr = getAttribute(i, node);
        var prop = $("#device-" + id + " td." + i);
        if (prop.html() != attr) {
            // if the value is new
            prop.addClass("fadeOut");
            if (i == "sensor_mac") {
                // if sensor_mac, embed the link to ibmcloud
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
};

$(document).ready(function(e) {
    ws.onopen = function() {
        console.log(ws);
    };
    ws.onmessage = function(msg) {
        var data = JSON.parse(msg.data);
        if (data.topic == "node") {
            //console.log(data.node);
            animateUpdate(data.node);
        }
    };
    ws.onclose = function() {
        console.log(ws);
        location.reload();
    };
});
