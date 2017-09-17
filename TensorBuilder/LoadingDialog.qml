import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

MyDialog {
	id: loading_dialog
	modal: true
	
	title: ''  
    closePolicy: Popup.NoAutoClose
	
	
	width: 200
	height: 100
	
	MyLabel {
		anchors.centerIn: parent
		font.bold: true
		font.pixelSize: 28
		text: qsTr('Loading...')
	}
}
