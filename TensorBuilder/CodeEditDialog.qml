import QtQuick 2.0
import QtQuick.Controls 2.2

MyDialog {
	id: code_edit_dialog
	modal: true
	
	title: qsTr("Edit Value")
	standardButtons: Dialog.Ok | Dialog.Cancel

	onAccepted: {
		node.input_values[index] = text_area.text
	}
	
	onNodeChanged: {
		if (node.input_values[index]) {
			text_area.text = (node.input_values[index]).toString()
		}
		else {
			text_area.text = ''
		}
	}
	
	width: 500
	height: parent.height * 0.75
	
	property var node
	property int index
	
	Rectangle {
		anchors.fill: parent
		color: '#dddddd'
		
		ScrollView {
			anchors.fill: parent
			anchors.margins: 10
			clip: true
		
			TextArea {
				id: text_area
				text: ""
				selectByKeyboard: true
				selectByMouse: true
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
