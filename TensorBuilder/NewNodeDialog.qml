import QtQuick 2.0
import QtQuick.Controls 2.2

MyDialog {
	id: new_node_dialog
	modal: true
	
	title: qsTr("New Node")
	// standardButtons: Dialog.Ok | Dialog.Cancel

	// onAccepted: console.log("Ok clicked")
	// onRejected: console.log("Cancel clicked")
	
	width: 450
	height: parent.height * 0.8
	
	Rectangle {
		anchors.fill: parent
		color: '#dddddd'
		
		ListView {
			id: new_node_list_view
			anchors.fill: parent
			
			interactive: true
			clip: true
			
			Component.onCompleted: {
				for (var i in main.definitions) {
					new_node_list_model.append({'definition': main.definitions[i]})
				}
			}
		
			model: ListModel {
				id: new_node_list_model
			}
			
			delegate: MyButton {
				height: 50
				width: parent.width
				
				text: definition.title
				buttonColor: definition.color
				
				onClicked: {
					var node = add_graph_node(definition)
					node.x = last_right_click_x
					node.y = last_right_click_y
					new_node_dialog.close()
				}
			}
			
			ScrollBar.vertical: ScrollBar {
				active: true
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
