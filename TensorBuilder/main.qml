import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: main
    visible: true
    width: 1024
    height: 768
    title: qsTr("TensorBuilder")
    property alias graphDisplay: graphDisplay
    
    property var types: [
		{
            'code': 'tf.float32',
        },
        {
            'code': 'tf.float16',
        },
        {
            'code': 'tf.float64',
        },
        // {
            // 'code': 'tf.bfloat16',
        // },
        {
            'code': 'tf.complex64',
        },
        {
            'code': 'tf.complex128',
        },
        {
            'code': 'tf.int8',
        },
        {
            'code': 'tf.uint8',
        },
        {
            'code': 'tf.uint16',
        },
        {
            'code': 'tf.int16',
        },
        {
            'code': 'tf.int32',
        },
        {
            'code': 'tf.int64',
        },
        {
            'code': 'tf.bool',
        },
        {
            'code': 'tf.string',
        },
        // {
            // 'code': 'tf.qint8',
        // },
        // {
            // 'code': 'tf.quint8',
        // },
        // {
            // 'code': 'tf.qint16',
        // },
        // {
            // 'code': 'tf.quint16',
        // },
        // {
            // 'code': 'tf.qint32',
        // },
        // {
            // 'code': 'tf.resource',
        // },
    ]
	
	readonly property string color_blue: '#3583d6'
	readonly property string color_red: '#fa6a35'
    readonly property string color_green: '#35ba6a'
    
    property var declarer: {
        ''
    }
    
    property var executer: {
        ''
    }
    
    property var definitions: [
        {
            'title': 'Placeholder',
			'color': color_blue,
            'code': 'tf.placeholder',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Type',
                    'type': 'type',
                    'default': 'float32',
                    'code': 'dtype',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
        },
        {
            'title': 'Uniform Random',
            'color': color_blue,
            'code': 'tf.random_uniform',
            'inputs': [
                {
                    'name': 'Shape',
                    'type': 'code',
					'default': '[1]',
                    'code': 'shape',
                },
                {
                    'name': 'Min',
                    'type': 'number',
					'default': '0.0',
                    'code': 'minval',
                },
                {
                    'name': 'Max',
                    'type': 'number',
					'default': '1.0',
                    'code': 'maxval',
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
            'code': 'tf.constant',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Value',
                    'type': 'code',
                    'default': 1.0,
                    'code': 'value',
                },
				{
					'name': 'Type',
                    'type': 'type',
                    'default': 'float32',
                    'code': 'dtype',
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
            'code': 'tf.Variable',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Init Value',
                    'type': 'number',
                    'default': 1.0,
                    'code': 'initial_value',
                },
				{
					'name': 'Type',
                    'type': 'type',
                    'default': 'float32',
                    'code': 'type',
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
            'code': 'tf.add',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Input 1',
                    'type': 'reference',
                    'default': null,
                    'code': 'x',
                },
				{
					'name': 'Input 2',
                    'type': 'reference',
                    'default': null,
                    'code': 'y',
                },
            ],
			'outputs': [
                {
					'name': 'Result',
                },
            ],
        },
		{
            'title': 'Subtract',
			'color': color_red,
            'code': 'tf.subtract',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Input 1',
                    'type': 'reference',
                    'default': null,
                    'code': 'x',
                },
				{
					'name': 'Input 2',
                    'type': 'reference',
                    'default': null,
                    'code': 'y',
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
            'code': 'tf.multiply',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Input 1',
                    'type': 'reference',
                    'default': null,
                    'code': 'x',
                },
				{
					'name': 'Input 2',
                    'type': 'reference',
                    'default': null,
                    'code': 'y',
                },
            ],
			'outputs': [
                {
					'name': 'Result',
                },
            ],
        },
		{
            'title': 'Matrix Multiply',
			'color': color_red,
            'code': 'tf.matmul',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
					'default': '',
                    'code': 'name',
                },
                {
					'name': 'Input 1',
                    'type': 'reference',
                    'default': null,
                    'code': 'a',
                },
				{
					'name': 'Input 2',
                    'type': 'reference',
                    'default': null,
                    'code': 'b',
                },
            ],
			'outputs': [
                {
					'name': 'Result',
                },
            ],
        },
        {
            'title': 'Squared Difference',
            'color': color_red,
            'code': 'tf.metrics.mean_squared_error',
            'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
                    'default': '',
                    'code': 'name',
                },
                {
                    'name': 'Input 1',
                    'type': 'reference',
                    'default': null,
                    'code': 'x',
                },
                {
                    'name': 'Input 2',
                    'type': 'reference',
                    'default': null,
                    'code': 'y',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
        },
        {
            'title': 'Softmax',
            'color': color_red,
            'code': 'tf.nn.softmax',
            'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
                    'default': '',
                    'code': 'name',
                },
                {
                    'name': 'Input',
                    'type': 'reference',
                    'default': null,
                    'code': 'logits',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
        },
		{
            'title': 'Execute',
			'color': color_green,
            'code': '',
			'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
                    'default': '',
                    'code': 'name',
                },
                {
                    'name': 'Node 1',
                    'type': 'reference',
                    'default': null,
                    'code': 'node1',
                },
                {
                    'name': 'Node 2',
                    'type': 'reference',
                    'default': null,
                    'code': 'node2',
                },
                {
                    'name': 'Node 3',
                    'type': 'reference',
                    'default': null,
                    'code': 'node3',
                },
                {
                    'name': 'Node 4',
                    'type': 'reference',
                    'default': null,
                    'code': 'node4',
                },
                {
					'name': 'Node 5',
                    'type': 'reference',
                    'default': null,
                    'code': 'node5',
                },
            ],
			'outputs': [
                {
					'name': 'Next',
                },
            ],
        },
    ]
	
    function repeat_str(string, count) {
        var result = string
        for (var i = 1; i < count; ++i) {
            result += string
        }
        return result
    }
    
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

    function add_prefix_strings(strings, prefix) {
        for (var i = 0; i < strings.length; i++){
            strings[i] = prefix + strings[i]
        }
    }

    function extend_array(array1, array2) {
        for (var i = 0; i < array2.length; i++){
            array1.push(array2[i])
        }
    }

    Component.onCompleted: {
        showMaximized()
    }
    
    
    GraphDisplay {
        id: graphDisplay
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
