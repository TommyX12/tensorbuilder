 import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    Rectangle{
        color: "#9abab2"
        anchors.fill: parent
    }

    function loadModels(newname) {
        model_list_model.clear()
        loading_text.text = "loading...";
        var http = new XMLHttpRequest()
        var url = "http://34.234.84.109:3000/models";
        http.open("GET", url, true);

        http.onreadystatechange = function() { // Call a function when the state changes.
            var definitions = [];
            if (http.readyState == 4) {
                if (http.status == 200) {
                    loading_text.text = "";
                    var jsondata = JSON.parse(http.responseText)
                    for (var i = 0; i < jsondata.length; i++) {
                        definitions.push({"name":jsondata[i]["name"]})
                    }
                    if (newname) {
                        // make sure the name isn't already in the list
                        var found = false
                        for (var i = 0; i < definitions.length; i++){
                            if (definitions[i]["name"] === newname){
                                found = true
                            }
                        }
                        // if we didn't find the name already, then add it to the list
                        if (!found) definitions.push({"name":newname})
                    }
                } else {
                    console.log("error: " + http.status)
                }
            }
            model_list_view.fillModels(definitions);
        }
        http.send();
    }

    // returns a JSON representationof the nodes
    function loadModel(name){
        var http = new XMLHttpRequest()
        var url = "http://34.234.84.109:3000/models/" + name;
        http.open("GET", url, true);

        http.onreadystatechange = function() { // Call a function when the state changes.
            var definitions = [];
            if (http.readyState == 4) {
                if (http.status == 200) {
                    var jsondata = JSON.parse(http.responseText)
                    var nodelist = []
                    for (var i = 0; i < jsondata["nodes"].length; i++) {
                        var nodedata = JSON.parse(jsondata["nodes"][i])
                        nodelist.push(nodedata)
                    }
                    loadNodes(nodelist)
                } else {
                    console.log("error: " + http.status)
                }
            }
        }
        http.send();
    }

    function loadNodes(nodelist) {
        // clear all current nodes first
        main.graphDisplay.remove_all_nodes()
        // loop through the node list to add each node to the graph
        for (var i = 0; i < nodelist.length; i++){
            for (var j = 0; j < main.definitions.length; j++){
                if (main.definitions[j]['title'] === nodelist[i]['definition']){
                    var node = graphDisplay.add_graph_node(main.definitions[j])
                    node.x = nodelist[i]['x']
                    node.y = nodelist[i]['y']
                }
            }
        }
        // loop through the nodes again but this time to add connections
        var nodes = main.graphDisplay.nodes
        for (var k = 0; k < nodelist.length; k++){
            var connections = nodelist[k]['connections']
            // loop through and set each connection
            for (var l = 0; l < connections.length; l++) {
                if (connections[l]){
                    var targetIndex = -1
                    for (var key in connections[l]){
                        targetIndex = key
                    }
                    nodes[k].set_connection(nodes[targetIndex], connections[l][key], l)
                }
            }
        }
    }

    Component.onCompleted: {
        loadModels()
    }

    Button {
        id: refresh_button
        anchors.top: parent.top
        height:100;
        width: parent.width

        text: "REFRESH"
        font.pixelSize: 30

        onClicked: loadModels()
    }

    Rectangle{

        color: "#9abab2"
        anchors.top: refresh_button.bottom
        width: parent.width
        anchors.bottom: name_field.top

        Text {
            id: loading_text
            font.pointSize: 30
            color: "white"

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

        ListView{
            id: model_list_view
            anchors.fill: parent

            interactive: true
            clip: true

            function fillModels(definitions) {
                for (var i in definitions) {
                    model_list_model.append({'definition': definitions[i]})
                    // console.log(definitions[i]["name"])
                }
            }

            model: ListModel{
                id: model_list_model
            }

            delegate: Button {
                height: 80
                width: parent.width

                MouseArea {
                    anchors.fill: parent
                    onClicked: loadModel(definition["name"])
                }

                text: definition["name"]
                font.pixelSize: 25
            }
        }
    }

    function uploadModel() {
        var graphnodes = main.graphDisplay.nodes
        var finalnodes = []
        // fill a JSON structure with node info
        for (var i = 0; i < graphnodes.length; i++){
            var node = graphnodes[i]
            var nodejson = {}
            // let the ID of each node just be their index in the array
            nodejson['ID'] = i
            nodejson['definition'] = node.definition["title"]
            nodejson['x'] = node.x
            nodejson['y'] = node.y
            var connections = node.connections
            var connectionarray = []
            for (var j = 0; j < connections.length; j++){
                if (connections[j]){
                    var connectionnode = connections[j]['from_node']
                    var connectionelement = {}
                    for (var k = 0; k < graphnodes.length; k++){
                        if (connectionnode === graphnodes[k]){
                             connectionelement[k] = connections[j]['from_index']
                        }
                    }
                    connectionarray.push(connectionelement)
                }else{
                    connectionarray.push(null)
                }
            }
            nodejson['connections'] = connectionarray
            finalnodes.push(JSON.stringify(nodejson))
        }

        var http = new XMLHttpRequest()
        var url = "http://34.234.84.109:3000/addmodel";
        http.open("POST", url, true);
        http.setRequestHeader("Content-type", "application/json");

        http.onreadystatechange = function() { // Call a function when the state changes.
            if (http.readyState == 4) {
                if (http.status == 200) {
                    console.log("success!")
                } else {
                    console.log("error: " + http.status)
                }
            }
            // load the model list again after post has gone through
        }
        var name = name_field.text !== "" ? name_field.text : "default"
        var data = {
            "name" : name,
            "nodes" : finalnodes
        }
        http.send(JSON.stringify(data))
        loadModels(name)
    }

    TextField {
        id: name_field
        anchors.bottom: upload_button.top
        placeholderText: "name"

        font.pointSize: 20

        width: parent.width
        horizontalAlignment: parent.Center
    }

    Button {
        id: upload_button
        anchors.bottom: parent.bottom
        height:100;
        width: parent.width

        text: "UPLOAD"
        font.pixelSize: 30

        onClicked: uploadModel()
    }

}
