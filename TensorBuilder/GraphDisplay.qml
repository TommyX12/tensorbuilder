import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
	id: graphDisplay
    color: '#eeeeee'
    
    property real offset_x: view.x
    property real offset_y: view.y
	property real view_scale: 1
    property real view_scale_rate: 0.25
	property real view_scale_min: 0.5
	property real view_scale_max: 4
	
	property bool target_set: false
	property var from_node: null
	property int from_index: 0
    
    Component {
        id: connection_component
        
        Connection {
            
        }
    }
	
	function start_dragging_connection(from_node, from_index) {
		dragging_connection.from_node  = from_node
		graphDisplay.from_node         = from_node
        graphDisplay.from_index        = from_index
		dragging_mouse_area.from_point = from_node.get_output_point(from_index)
		dragging_mouse_area.dragging   = true
	}
	
	function end_dragging_connection(to_node, to_index) {
        to_node.set_connection(from_node, from_index, to_index)
	}
    
    function add_connection_visual(from_node, from_index, to_node, to_index) {
        return connection_component.createObject(
            view,
            {
                'from_node': from_node,
                'from_index': from_index,
                'to_node': to_node,
                'to_index': to_index,
            }
        )
    }
	
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
		
		GraphNode {
			id: node1
			x: 100
			y: 100
			definition: main.definitions[0]
		}
		GraphNode {
            id: node2
			x: 200
			y: 300
            definition: main.definitions[1]
		}
		GraphNode {
            id: node3
			x: 200
			y: 500
            definition: main.definitions[2]
		}
		GraphNode {
            id: node4
			x: 250
			y: 600
            definition: main.definitions[3]
		}
		GraphNode {
            id: node5
			x: 550
			y: 600
            definition: main.definitions[4]
		}
		Connection {
            id: dragging_connection
            visible: false
            enabled: visible
		}
    }
    
	MouseArea {
		id: dragging_mouse_area
		enabled: true
		anchors.fill: parent
		propagateComposedEvents: true
		hoverEnabled: dragging
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        property var from_point: null
		property bool dragging: false
		
		onDraggingChanged: {
			if (dragging) {
				
				dragging_connection.visible = true
				dragging_connection.canvas_rect = dragging_connection.get_canvas_rect(
							from_point, from_point)
				entered({accepted: true})
			}
			else {
				
			}
		}
		
		onPressed: function (event) {
			if (event.button === Qt.RightButton) {
                right_click_menu.open()
				right_click_menu.x = event.x - 25
				right_click_menu.y = event.y - 25
				return
            }
			
			if (!dragging) {
				target_set = false
				event.accepted = false
			}
			else {
				dragging_connection.visible = dragging = false
				target_set = true
				event.accepted = false
			}
		}
		
		onReleased: {
			
		}
		
		onPositionChanged: function (event) {
			if (dragging) {
				dragging_connection.canvas_rect = dragging_connection.get_canvas_rect(
							from_point, {
								x: (event.x - offset_x) / view_scale,
                                y: (event.y - offset_y) / view_scale,
							})
			}
			event.accepted = false;
		}
	}
    
    Menu {
        id: right_click_menu
        y: 0

        MenuItem {
            text: "New..."
        }
    }
}
