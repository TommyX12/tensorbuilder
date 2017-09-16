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
            'title': 'Placeholder',
			'color': color_blue,
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'literal',
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
            'title': 'Constant',
			'color': color_blue,
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'literal',
                },
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
            'title': 'Variable',
			'color': color_blue,
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'literal',
                },
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
            'title': 'Add',
			'color': color_red,
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'literal',
                },
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
            'title': 'Multiply',
			'color': color_red,
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'literal',
                },
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
    
    function hsl(r, g, b) {
        
        //http://www.easyrgb.com/index.php?X=MATH&H=18#text18
        
        var var_Min = Math.min( r, g, b )    //Min. value of RGB
        var var_Max = Math.max( r, g, b )    //Max. value of RGB
        var del_Max = var_Max - var_Min             //Delta RGB value
        
        var L = ( var_Max + var_Min ) / 2
        var H = 0.0, S = 0.0
        
        if ( del_Max == 0 )                     //This is a gray, no chroma...
        {
           H = 0                                //HSL results from 0 to 1
           S = 0
        }
        else                                    //Chromatic data...
        {
           if ( L < 0.5 ) S = del_Max / ( var_Max + var_Min )
           else           S = del_Max / ( 2 - var_Max - var_Min )
        
           var del_R = ( ( ( var_Max - r ) / 6 ) + ( del_Max / 2 ) ) / del_Max
           var del_G = ( ( ( var_Max - g ) / 6 ) + ( del_Max / 2 ) ) / del_Max
           var del_B = ( ( ( var_Max - b ) / 6 ) + ( del_Max / 2 ) ) / del_Max
        
           if      ( r == var_Max ) H = del_B - del_G
           else if ( g == var_Max ) H = ( 1 / 3 ) + del_R - del_B
           else if ( b == var_Max ) H = ( 2 / 3 ) + del_G - del_R
        
           if ( H < 0 ) H += 1
           if ( H > 1 ) H -= 1
        }
        
        return {h: H, s: S, l: L};
    }

    function luma(r, g, b){
        return 0.299 * r + 0.587 * g + 0.114 * b;
    }

    
    Component.onCompleted: {
        showMaximized()
    }
    
    
    GraphDisplay {
        anchors.left:   modelBrowser.right
        anchors.right:  parent.right
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
    }
    
    ModelBrowser {
        id: modelBrowser
        anchors.left:   parent.left
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        width: 400
    }
    
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
