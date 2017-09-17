 import QtQuick 2.0

Item {

    function loadModels() {
        /*
        var doc = new XMLHttpRequest()
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
                console.log("Headers -->");
                console.log(doc.getAllResponseHeaders ());
                console.log("Last modified -->");
                console.log(doc.getResponseHeader ("Last-Modified"));

            } else if (doc.readyState == XMLHttpRequest.DONE) {
                var a = doc.responseXML.documentElement;
                for (var ii = 0; ii < a.childNodes.length; ++ii) {
                    console.log(a.childNodes[ii].nodeName);
                }
                console.log("Headers -->");
                console.log(doc.getAllResponseHeaders ());
                console.log("Last modified -->");
                console.log(doc.getResponseHeader ("Last-Modified"));
            }
        }
        doc.open("GET", "http://34.234.84.109:3000/models")
        doc.send()
        */
        var http = new XMLHttpRequest()
        var url = "http://34.234.84.109:3000/models";
        http.open("GET", url, true);

        http.onreadystatechange = function() { // Call a function when the state changes.
            if (http.readyState == 4) {
                if (http.status == 200) {
                    var jsondata = JSON.parse(http.responseText)
                    for (var i = 0; i < jsondata.length; i++) {
                        console.log(jsondata[i]["name"])
                    }
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
        color: "green"
    }

}
