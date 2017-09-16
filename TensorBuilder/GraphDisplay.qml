import QtQuick 2.0

Rectangle {
    color: '#eeeeee'
    
    property real offset_x: 0
    property real offset_y: 0
	property real view_scale: 1
    property real view_scale_rate: 0.25
	property real view_scale_min: 0.5
	property real view_scale_max: 4
	
	MouseArea {
        anchors.fill: parent
        drag.target: view
		
		onWheel: function (event) {
			view_scale = clamp(view_scale + event.angleDelta.y / 360.0 * view_scale_rate, view_scale_min, view_scale_max)
		}
    }
    
    Item {
        id: view
        width: 100
        height: 100
		
		transform: Scale {
			xScale: view_scale
			yScale: view_scale
		}
		
		x: offset_y
		y: offset_x
		
		GraphNode {
			x: 100
			y: 100
			definition: main.definitions[0]
		}
		GraphNode {
			x: 200
			y: 300
            definition: main.definitions[1]
		}
		GraphNode {
			x: 200
			y: 500
            definition: main.definitions[2]
		}
		GraphNode {
			x: 250
			y: 600
            definition: main.definitions[3]
		}
		GraphNode {
			x: 550
			y: 600
            definition: main.definitions[4]
		}
    }
    
    
}
