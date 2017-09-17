 import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    function loadModels() {
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
                        // console.log(jsondata[i]["name"])
                        definitions.push({"name":jsondata[i]["name"]})
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
        // clear all current nodes first
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
        for (var i = 0; i < nodelist.length; i++){
            console.log(JSON.stringify(nodelist[i]))
            for (var j = 0; j < main.definitions.length; j++){
                if (main.definitions[j]['title'] === nodelist[i]['definition']){
                    var node = graphDisplay.add_graph_node(main.definitions[j])
                    node.x = nodelist[i]['x']
                    node.y = nodelist[i]['y']
                }
            }
        }
    }

    Component.onCompleted: {
        loadModels()
    }

    Rectangle{
        anchors.fill: parent
        color: "#9abab2"

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
        }
        // TODO: give the ability to change the name of the model
        var data = {
            "name" : "temp",
            "nodes" : finalnodes
        }
        http.send(JSON.stringify(data))
    }

    Button {
        anchors.bottom: parent.bottom
        height:100;
        width: parent.width

        text: "UPLOAD"
        font.pixelSize: 30

        onClicked: uploadModel()
    }

}
