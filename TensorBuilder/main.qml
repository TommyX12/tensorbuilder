import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: main
    visible: true
    width: 1024
    height: 768
    title: qsTr("TensorBuilder")
    
    property var types: [
		{
            'name': 'float32',
            'python': 'tf.float32',
        },
        {
            'name': 'float16',
            'python': 'tf.float16',
        },
        {
            'name': 'float64',
            'python': 'tf.float64',
        },
        // {
            // 'name': 'bfloat16',
            // 'python': 'tf.bfloat16',
        // },
        {
            'name': 'complex64',
            'python': 'tf.complex64',
        },
        {
            'name': 'complex128',
            'python': 'tf.complex128',
        },
        {
            'name': 'int8',
            'python': 'tf.int8',
        },
        {
            'name': 'uint8',
            'python': 'tf.uint8',
        },
        {
            'name': 'uint16',
            'python': 'tf.uint16',
        },
        {
            'name': 'int16',
            'python': 'tf.int16',
        },
        {
            'name': 'int32',
            'python': 'tf.int32',
        },
        {
            'name': 'int64',
            'python': 'tf.int64',
        },
        {
            'name': 'bool',
            'python': 'tf.bool',
        },
        {
            'name': 'string',
            'python': 'tf.string',
        },
        // {
            // 'name': 'qint8',
            // 'python': 'tf.qint8',
        // },
        // {
            // 'name': 'quint8',
            // 'python': 'tf.quint8',
        // },
        // {
            // 'name': 'qint16',
            // 'python': 'tf.qint16',
        // },
        // {
            // 'name': 'quint16',
            // 'python': 'tf.quint16',
        // },
        // {
            // 'name': 'qint32',
            // 'python': 'tf.qint32',
        // },
        // {
            // 'name': 'resource',
            // 'python': 'tf.resource',
        // },
    ]
	
	readonly property string color_blue: '#3583d6'
	readonly property string color_red: '#fa6a35'
    
    property var definitions: [
        {
            'name': 'Placeholder',
			'color': color_blue,
			'inputs': [
                {
					'name': 'Type',
                    'type': 'type',
                    'default': 'float32',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
        },
		{
            'name': 'Constant',
			'color': color_blue,
			'inputs': [
                {
					'name': 'Value',
                    'type': 'literal',
                    'default': 1.0,
                },
				{
					'name': 'Type',
                    'type': 'type',
                    'default': 'float32',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
        },
		{
            'name': 'Variable',
			'color': color_blue,
			'inputs': [
                {
					'name': 'Init Value',
                    'type': 'literal',
                    'default': 1.0,
                },
				{
					'name': 'Type',
                    'type': 'type',
                    'default': 'float32',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
        },
		{
            'name': 'Add',
			'color': color_red,
			'inputs': [
                {
					'name': 'Node 1',
                    'type': 'reference',
                    'default': null,
                },
				{
					'name': 'Node 2',
                    'type': 'reference',
                    'default': null,
                },
            ],
			'outputs': [
                {
					'name': 'Result',
                },
            ],
        },
		{
            'name': 'Multiply',
			'color': color_red,
			'inputs': [
                {
					'name': 'Node 1',
                    'type': 'reference',
                    'default': null,
                },
				{
					'name': 'Node 2',
                    'type': 'reference',
                    'default': null,
                },
            ],
			'outputs': [
                {
					'name': 'Result',
                },
            ],
        },
    ]
	
	function clamp(x, a, b) {
		return Math.min(Math.max(x, a), b)
	}
	
	function lerp(a, b, x) {
		return a + (b - a) * x
	}
	
	function random(a, b) {
		return a + Math.random() * (b - a)
	}
    
    Component.onCompleted: {
        showMaximized()
    }
    
    
    GraphDisplay {
        anchors.fill: parent
    }
    
    // SelectionPanel {
        // id: selectionPanel
        // anchors.left:   parent.left
        // anchors.top:    parent.top
        // anchors.bottom: parent.bottom
        // width: 250
    // }
    
    // SwipeView {
        // id: swipeView
        // anchors.fill: parent
        // currentIndex: tabBar.currentIndex
        
        // Page1 {
            
        // }
        
        // Page {
            // Label {
                // text: qsTr("Second page")
                // anchors.centerIn: parent
            // }
        // }
    // }
    
    // footer: TabBar {
        // id: tabBar
        // currentIndex: swipeView.currentIndex
        // TabButton {
            // text: qsTr("First")
        // }
        // TabButton {
            // text: qsTr("Second")
        // }
    // }
}
