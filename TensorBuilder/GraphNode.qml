import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Rectangle {
    color: '#e0e0e0'
    
    //width: childrenRect.height
	width: 300
    height: childrenRect.height
    
    property var definition: null
    property var values:     ({})
    property var inputs: ({})
	property var outputs: ({})
    
    readonly property real input_height: 60
	readonly property real output_height: 30
    
    onDefinitionChanged: {
        if (definition !== null) {
            input_list_model.clear()
            for (var i in definition['inputs']) {
                input_list_model.append(definition['inputs'][i])
            }
            output_list_model.clear()
			for (var i in definition['outputs']) {
				output_list_model.append(definition['outputs'][i])
			}
        }
    }
    
    MouseArea {
        anchors.fill: parent
        drag.target: parent
		
    }
	
	ColumnLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		
		spacing: 0
		
		Rectangle {
			color: '#fa6a35'
			border.width: 2
			border.color: '#ffffff'
			
			Layout.fillWidth: true
			height: 40
			
			MyLabel {
				id: title
				anchors.left: parent.left
				anchors.leftMargin: 10
				text: definition === null ? '' : definition['name']
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
					height: input_height
					width: 150
					
					Rectangle {
						height: parent.height
						width: 150
						border.width: 2
						border.color: '#aaaaaa'
						color: {
							if (input_item_area.pressed) {
								return '#aaaaaa'
							}
							else if (input_item_area.containsMouse) {
								return '#ffffff'
							}
							else return '#cccccc'
						}

						MouseArea {
							id: input_item_area
							anchors.fill: parent
							hoverEnabled: true
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
							text: name
						}
						
						ComboBox {
							Layout.fillHeight: true
							Layout.fillWidth: true
							Layout.minimumWidth: 10
							Layout.maximumWidth: 65536
							visible: type === 'type'
							model: {
								var result = []
								for (var i in main.types) {
									result.push(main.types[i]['name'])
								}
								
								return result
							}
						}
						
						
						TextField {
							height: 26
							Layout.fillWidth: true
							Layout.minimumWidth: 10
							Layout.maximumWidth: 65536
							visible: type === 'literal'
							selectByMouse: true
							placeholderText: qsTr('(value)')
						}
						
						
						MyLabel {
							height: 30
							anchors.verticalCenter: undefined
							Layout.fillWidth: true
							Layout.fillHeight: true
							Layout.minimumWidth: 10
							Layout.maximumWidth: 65536
							visible: type === 'input'
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
					
					Rectangle {
						height: parent.height
						width: 150
						x: -width
						border.width: 2
						border.color: '#aaaaaa'
						color: {
							if (output_item_area.pressed) {
								return '#aaaaaa'
							}
							else if (output_item_area.containsMouse) {
								return '#ffffff'
							}
							else return '#cccccc'
						}

						MouseArea {
							id: output_item_area
							anchors.fill: parent
							hoverEnabled: true
						}
					}
					
					MyLabel {
						anchors.fill: parent
						anchors.rightMargin: 10
						text: name
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
		border.color: '#888888'
	}
}
