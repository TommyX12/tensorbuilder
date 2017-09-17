import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

MyDialog {
	id: help_dialog
	modal: true
	
	title: {
		return qsTr('Help')
	}
    
	standardButtons: Dialog.Ok
	
	property bool is_running: false

	
	width: 600
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
				text: qsTr("- To start, right click on the canvas and select <New Node...>.\n- Drag to replace the nodes.\n- Click on output ports of nodes to start connecting, then click on destination input port.\n- Right click on a node to delete or execute.\n\n- On the bottom-left, you can name your model and upload to community.\n- Click on uploaded models to start editing.")
				selectByKeyboard: true
				selectByMouse: true
				readOnly: true
				
				font.pixelSize: 22
				
				wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
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
