import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

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
    readonly property string color_purple: '#aa6a95'
    readonly property string color_green: '#35ba6a'
    readonly property string color_grey: '#666666'
    
    property var declarers: {
        'tf_node': function (node) {
            var lines = []
            var line = node.temp_names[0] + ' = ' + node.definition.code + '('
            var first = true
            for (var param_code in node.temp_params) {
                var param = node.temp_params[param_code]
                if (!first) {
                    line += ', '
                }
                else {
                    first = false
                }
                line += param_code + '=(' + param.code_str + ')'
            }
            
            line += ')'
            lines.push(line)
            
            return lines
        },
        'mnist': function (node) {
            var lines = [
                'from tensorflow.examples.tutorials.mnist import input_data',
                'mnist = input_data.read_data_sets("MNIST_data/", one_hot = True)',
                node.temp_names[0] + ', ' + node.temp_names[1] + ' = mnist.train.next_batch(1000)',
                node.temp_names[2] + ' = mnist.test.images',
                node.temp_names[3] + ' = mnist.test.labels',
            ]
            
            return lines
        },
        'global_var': function (node) {
            var lines = [
                node.temp_names[0] + ' = None'
            ]
            return lines
        },
        'none': function (node) {
            return []
        },
    }
    
    property var executers: {
        'tf_node': function (node) {
            var lines = [
                '_ = session.run(' + node.temp_names[0] + ', feed_dict)',
                'if _ is not None: print(\'' + (node.temp_params.name ? node.temp_params.name.value : '') + ': {0}\'.format(_))',
            ]
            
            return lines
        },
        'multi_exec': function (node) {
            var lines = []
            for (var i in node.connections) {
                if (!node.connections[i]) continue
                extend_array(lines, node.connections[i].from_node.get_execution())
            }
            
            return lines
        },
        'repeater': function (node) {
            var lines = []
            lines.push('for i in range(' + node.temp_params.iterations.code_str + '):')
            if (node.temp_params.node.value) {
                var sub_lines = []
                sub_lines.push('if i % 100 == 0: print(\'iteration {0}...\'.format(i))')
                extend_array(sub_lines, node.temp_params.node.value.from_node.get_execution())
                add_prefix_strings(sub_lines, '    ')
                extend_array(lines, sub_lines)
            }
            
            return lines
        },
        'set_placeholder': function (node) {
            var lines = [
                'feed_dict[' + node.temp_params.name.code_str + ' + \':0\'] = ' + node.temp_params.value.code_str,
            ]
            
            return lines
        },
        'global_var': function (node) {
            var lines = [
                'if ' + node.temp_names[0] + ' is None: ' + node.temp_names[0] + ' = ' + node.definition.code + '()',
                'session.run(' + node.temp_names[0] + ')',
            ]
            return lines
        },
        'none': function (node) {
            return []
        },
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
                    'default': 'tf.float32',
                    'code': 'dtype',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
                    'default': 'tf.float32',
                    'code': 'dtype',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
                    'type': 'reference',
                    'default': '',
                    'code': 'initial_value',
                },
				{
					'name': 'Type',
                    'type': 'type',
                    'default': 'tf.float32',
                    'code': 'dtype',
                },
            ],
			'outputs': [
                {
					'name': 'Value',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Negative',
            'color': color_red,
            'code': 'tf.negative',
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
                    'code': 'x',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Log',
            'color': color_red,
            'code': 'tf.log',
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
                    'code': 'x',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Squared Difference',
            'color': color_red,
            'code': 'tf.squared_difference',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Reduce Sum',
            'color': color_red,
            'code': 'tf.reduce_sum',
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
                    'code': 'input_tensor',
                },
                {
                    'name': 'Axis',
                    'type': 'number',
                    'default': 0,
                    'code': 'axis',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Arg Max',
            'color': color_red,
            'code': 'tf.argmax',
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
                    'code': 'input',
                },
                {
                    'name': 'Axis',
                    'type': 'number',
                    'default': 0,
                    'code': 'axis',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Reduce Mean',
            'color': color_red,
            'code': 'tf.reduce_mean',
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
                    'code': 'input_tensor',
                },
                {
                    'name': 'Axis',
                    'type': 'number',
                    'default': 0,
                    'code': 'axis',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Cast',
            'color': color_red,
            'code': 'tf.cast',
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
                    'code': 'x',
                },
                {
                    'name': 'Type',
                    'type': 'type',
                    'default': 'tf.float32',
                    'code': 'dtype',
                },
            ],
            'outputs': [
                {
                    'name': 'Result',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Equals',
            'color': color_red,
            'code': 'tf.equal',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
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
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
        {
            'title': 'Initialize',
            'color': color_green,
            'code': 'tf.global_variables_initializer',
            'inputs': [
                
            ],
            'outputs': [
                {
                    'name': 'Run',
                },
            ],
            'declarer': 'global_var',
            'executer': 'global_var',
        },
        {
            'title': 'Execute',
            'color': color_green,
            'code': '',
            'inputs': [
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
                    'name': 'Run',
                },
            ],
            'declarer': 'none',
            'executer': 'multi_exec',
        },
        {
            'title': 'Repeater',
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
                    'name': 'Node',
                    'type': 'reference',
                    'default': null,
                    'code': 'node',
                },
                {
                    'name': 'Iterations',
                    'type': 'number',
                    'default': 100,
                    'code': 'iterations',
                },
            ],
            'outputs': [
                {
                    'name': 'Run',
                },
            ],
            'declarer': 'none',
            'executer': 'repeater',
        },
        {
            'title': 'Set Placeholder',
            'color': color_green,
            'code': '',
            'inputs': [
                {
                    'name': 'Placeholder',
                    'type': 'string',
                    'default': '',
                    'code': 'name',
                },
                {
                    'name': 'Value',
                    'type': 'code',
                    'default': '',
                    'code': 'value',
                },
            ],
            'outputs': [
                {
                    'name': 'Run',
                },
            ],
            'declarer': 'none',
            'executer': 'set_placeholder',
        },
        {
            'title': 'Set Placeholder Ref',
            'color': color_green,
            'code': '',
            'inputs': [
                {
                    'name': 'Placeholder',
                    'type': 'string',
                    'default': '',
                    'code': 'name',
                },
                {
                    'name': 'Value',
                    'type': 'reference',
                    'default': null,
                    'code': 'value',
                },
            ],
            'outputs': [
                {
                    'name': 'Run',
                },
            ],
            'declarer': 'none',
            'executer': 'set_placeholder',
        },
        {
            'title': 'Minimize Step',
            'color': color_purple,
            'code': 'tf.train.GradientDescentOptimizer(0.5).minimize',
            'inputs': [
                {
                    'name': 'Name',
                    'type': 'string',
                    'default': '',
                    'code': 'name',
                },
                {
                    'name': 'Cost Function',
                    'type': 'reference',
                    'default': null,
                    'code': 'loss',
                },
            ],
            'outputs': [
                {
                    'name': 'Run',
                },
            ],
            'declarer': 'tf_node',
            'executer': 'tf_node',
        },
		{
            'title': 'MNIST Data',
			'color': color_grey,
            'code': '',
			'inputs': [
                
            ],
			'outputs': [
                {
                    'name': 'Train Input',
                },
                {
                    'name': 'Train Labels',
                },
                {
                    'name': 'Test Input',
                },
                {
					'name': 'Test Labels',
                },
            ],
            'declarer': 'mnist',
            'executer': 'none',
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
	
	
	Item {
		anchors.top: top_bar.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
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
			width: 320
		}
	}
	Rectangle {
		id: top_bar
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: 60
		color: '#d66321'
		
		MyLabel {
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 30
			font.pixelSize: 25
			text: qsTr('TensorBuilder')
			color: '#eeeeee'
		}
		
		ToolButton {
			anchors.right: parent.right
			anchors.rightMargin: 30
			anchors.verticalCenter: parent.verticalCenter
			text: qsTr('Help')
			onClicked: graphDisplay.show_help()
		}
	}
	DropShadow {
		anchors.fill: top_bar
		horizontalOffset: 0
		verticalOffset: 0
		radius: 12.0
		samples: 16
		color: "#80000000"
		source: top_bar
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
