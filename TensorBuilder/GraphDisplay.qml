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
    
    property real last_right_click_x: 0
    property real last_right_click_y: 0
    
    property var nodes: []
    
    Component {
        id: graph_node_component
        
        GraphNode {
            
        }
    }
    
    Component {
        id: connection_component
        
        Connection {
            
        }
    }
    
    function add_graph_node(definition) {
        var node = graph_node_component.createObject(
            view,
            {
                'definition': definition,
            }
        )
        
        nodes.push(node)
        
        return node
    }
    
    function remove_graph_node(node) {
        for (var i in node.connections) {
            node.remove_connection(i)
        }
        var index
        for (var i in nodes) {
            var _node = nodes[i]
            if (_node === node) {
                console.log('found')
                index = i
                continue
            }
            for (var j in _node.connections) {
                if (_node.connections[j] !== null && _node.connections[j].from_node === node) {
                    _node.remove_connection(j)
                }
            }
        }
        
        nodes.splice(index, 1)
        
        node.destroy()
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
    
    Component.onCompleted: {
        
    }
	
	MouseArea {
        anchors.fill: parent
        drag.target: view
		
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		
		onWheel: function (event) {
			var old_scale = view_scale
			view_scale = clamp(view_scale + event.angleDelta.y / 360.0 * view_scale_rate, view_scale_min, view_scale_max)
			view.x = lerp(event.x, view.x, view_scale / old_scale)
			view.y = lerp(event.y, view.y, view_scale / old_scale)
		}
		
		onClicked: function (event) {
            if (event.button === Qt.RightButton) {
                right_click_menu.open()
                right_click_menu.x = event.x - 10
                right_click_menu.y = event.y - 10
                last_right_click_x = event.x
                last_right_click_y = event.y
                return
            }
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
        property var from_point: null
		property bool dragging: false
        property real last_click_x: 0
        property real last_click_y: 0
		
		onDraggingChanged: {
			if (dragging) {
				
				dragging_connection.visible = true
				dragging_connection.canvas_rect = dragging_connection.get_canvas_rect(
							from_point, {x: last_click_x, y: last_click_y})
				entered({accepted: true})
			}
			else {
				
			}
		}
		
		onPressed: function (event) {
            last_click_x = event.x
            last_click_y = event.y
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
			text: qsTr('New...')
			
			onTriggered: {
				new_node_dialog.open()
			}
		}
	}
	
	NewNodeDialog {
		id: new_node_dialog
	}
}
