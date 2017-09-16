import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {
	id: node
    color: '#e0e0e0'
    
    //width: childrenRect.height
	width: 300
    height: childrenRect.height
    
    property var definition:          null
	property var connections:         []
    property var connections_visual:  []
	property var input_values:        []
	
	readonly property real title_height: 40
    readonly property real input_height: 60
	readonly property real output_height: 30
    
    onDefinitionChanged: {
        if (definition !== null) {
            input_list_model.clear()
            connections        = []
            connections_visual = []
			input_values = []
            for (var i in definition['inputs']) {
				var input_definition = definition['inputs'][i]
				input_list_model.append({'definition': input_definition, 'index': i})
                connections.push(null)
                connections_visual.push(null)
				input_values.push(input_definition.default)
            }
            output_list_model.clear()
			for (var i in definition['outputs']) {
				output_list_model.append({'definition': definition['outputs'][i], 'index': i})
			}
        }
    }
	
	function get_input_point(index) {
		return {
			'x': x + 0,
			'y': y + title_height + index * input_height,
		}
	}
	function get_output_point(index) {
		return {
			'x': x + width,
			'y': y + title_height + index * output_height,
		}
	}
	
	function set_connection(from_node, from_index, index) {
        if (definition.inputs[index].type !== 'reference') return
        
        if (connections[index] !== null) {
            remove_connection(index)
        }
        
        var connection = {
            'from_node':  from_node,
            'from_index': from_index,
        }
        
        connections[index] = connection
        
		connections_visual[index] = graphDisplay.add_connection_visual(from_node, from_index, node, index)
        
	}
    
    function remove_connection(index) {
        if (connections[index] === null) return
        
		connections_visual[index].destroy()
        connections[index] = null
    }
    
    MouseArea {
        anchors.fill: parent
        drag.target: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onClicked: function (event) {
            if (event.button === Qt.RightButton) {
                right_click_menu.open()
                right_click_menu.x = event.x - 10
                right_click_menu.y = event.y - 10
                return
            }
        }
		
        Menu {
            id: right_click_menu
            y: 0

            MenuItem {
                text: qsTr('Delete')
                
                onTriggered: {
                    graphDisplay.remove_graph_node(node)
                }
            }
			
			MenuItem {
                text: qsTr('Run')
                
                onTriggered: {
                    
                }
            }
        }
    }
	
	ColumnLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		
		spacing: 0
		
		Rectangle {
			color: definition === null ? 'black' : definition.color
			border.width: 2
			border.color: '#ffffff'
			
			Layout.fillWidth: true
			height: title_height
			
			MyLabel {
				id: title
				anchors.left: parent.left
				anchors.leftMargin: 10
				text: definition === null ? '' : definition['title']
				color: '#ffffff'
			}
		}
		
		RowLayout {
			Layout.minimumWidth: 10
			Layout.maximumWidth: 65536
			spacing: 0
			ListView {
				id: input_list_view
				height: input_height * count
				width: 300
				Layout.alignment: Qt.AlignTop
				
				interactive: false
			
				model: ListModel {
					id: input_list_model
				}
				
				delegate: Item {
					id: input_list_delegate
					height: input_height
					width: 150
					
					Button {
						height: parent.height + 10
						y: -5
						width: 150
						flat: true
						
						onPressed: function (event) {
							if (graphDisplay.target_set) {
								graphDisplay.end_dragging_connection(node, index)
							}
							else {
								if (node.connections[index]) {
									var from_node = node.connections[index].from_node
									var from_index = node.connections[index].from_index
									
									node.remove_connection(index)
									
									graphDisplay.start_dragging_connection(from_node, from_index)
								}
							}
						}
					}
					
					ColumnLayout {
						anchors.fill: parent
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						spacing: 0
						
						MyLabel {
							anchors.top: parent.top
							width: 50
							height: 30
							text: definition.name
						}
						
						ComboBox {
							Layout.fillHeight: true
							Layout.fillWidth: true
							Layout.minimumWidth: 10
							Layout.maximumWidth: 65536
							visible: definition.type === 'type'
							model: {
								var result = []
								for (var i in main.types) {
									result.push(main.types[i]['name'])
								}
								
								return result
							}
							
							onActivated: function (i) {
								if (!visible) return
								input_values[index] = model[i]
							}
						}
						
						
                        TextField {
                            id: input_literal_field
                            height: 22
                            Layout.fillWidth: true
                            Layout.minimumWidth: 10
                            Layout.maximumWidth: 65536
                            visible: definition.type === 'literal'
                            selectByMouse: true
                            placeholderText: qsTr('(input)')
							
							onTextChanged: {
								if (!visible) return
								input_values[index] = text
							}
                        }
                        
						MyButton {
							height: 30
							Layout.fillWidth: true
							Layout.minimumWidth: 10
							Layout.maximumWidth: 65536
							visible: definition.type === 'code'
                            text: qsTr('Edit')
							
							onClicked: {
								graphDisplay.show_code_editor(node, index)
							}
						}
						
						MyLabel {
							height: 30
							anchors.verticalCenter: undefined
							Layout.fillWidth: true
							Layout.fillHeight: true
							Layout.minimumWidth: 10
							Layout.maximumWidth: 65536
							visible: definition.type === 'reference'
							text: qsTr('(reference)')
							font.pixelSize: 14
							color: 'gray'
						}
					}
					
				}
			}
			
			ListView {
				id: output_list_view
				height: output_height * count
				width: 300
				Layout.alignment: Qt.AlignTop
				
				interactive: false
			
				model: ListModel {
					id: output_list_model
				}
				
				delegate: Item {
					height: output_height
					
					Button {
						height: parent.height + 10
						y: -5
						width: 150
						x: -width
						
						onPressed: {
							graphDisplay.start_dragging_connection(node, index)
						}
						onReleased: {
							
						}
					}
					
					MyLabel {
						anchors.fill: parent
						anchors.rightMargin: 10
						text: definition.name
						horizontalAlignment: Text.AlignRight
					}
				}
			}
		}
	}	
    
	Rectangle {
		anchors.fill: parent
		color: 'transparent'
		border.width: 2
		border.color: '#a0a0a0'
	}
	
}
