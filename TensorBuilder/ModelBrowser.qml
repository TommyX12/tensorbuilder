 import QtQuick 2.0

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

            delegate: Rectangle {
                height: 80
                width: parent.width

                color: "#afcec6"

                Text {
                    text: definition["name"]

                    width: parent.width
                    height: parent.height

                    font.pointSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

}
