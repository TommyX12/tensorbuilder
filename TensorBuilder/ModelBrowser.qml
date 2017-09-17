 import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    function loadModels() {
        var http = new XMLHttpRequest()
        var url = "http://34.234.84.109:3000/models";
        http.open("GET", url, true);

        http.onreadystatechange = function() { // Call a function when the state changes.
            var definitions = [];
            if (http.readyState == 4) {
                if (http.status == 200) {
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
        var http = new XMLHttpRequest()
        var url = "http://34.234.84.109:3000/models/" + name;
        http.open("GET", url, true);

        http.onreadystatechange = function() { // Call a function when the state changes.
            var definitions = [];
            if (http.readyState == 4) {
                if (http.status == 200) {
                    var jsondata = JSON.parse(http.responseText)
                    console.log(jsondata["nodes"])
                    // TODO: actually load the nodes into the application
                } else {
                    console.log("error: " + http.status)
                }
            }
        }
        http.send();
    }

    Component.onCompleted: loadModels()

    Rectangle{
        anchors.fill: parent
        color: "#9abab2"

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
        // Change the data to upload actual models
        var data = {
            "name" : "temp",
            "nodes" : []
        }
        console.log(data)
        http.send(JSON.stringify(data));
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
