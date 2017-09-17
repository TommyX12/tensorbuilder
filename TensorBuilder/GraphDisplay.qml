import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
	id: graphDisplay
    color: '#eeeeee'
    
    property real offset_x: view.x
    property real offset_y: view.y
	property real view_scale: 1
    property real view_scale_rate: 0.25
	property real view_scale_min: 0.1
	property real view_scale_max: 4
	
	property bool target_set: false
	property var from_node: null
	property int from_index: 0
    
    property real last_right_click_x: 0
    property real last_right_click_y: 0
    
    property var nodes: []
    
    Component {
        id: graph_node_component
        
        GraphNode {
            
        }
    }
    
    Component {
        id: connection_component
        
        Connection {
            
        }
    }
    
    function add_graph_node(definition) {
        var node = graph_node_component.createObject(
            view,
            {
                'definition': definition,
            }
        )
        
        nodes.push(node)
        
        return node
    }
	
	function show_code_editor(node, index) {
		code_edit_dialog.index = index
        code_edit_dialog.node = node
		code_edit_dialog.open()
	}
	
	function run_node(node) {
        var script
        script = 'import math, os\n'+
		'from tensorflow.examples.tutorials.mnist import input_data\n'+
		'import tensorflow as tf\n'+
		'\n'+
		'mnist = input_data.read_data_sets("MNIST_data/", one_hot = True)\n'+
		'\n'+
		'#  print(tf.Session().run(tf.constant(\'Hello, World!\')))\n'+
		'\n'+
		'input_dim_raw = 28\n'+
		'input_dim     = 28 * 28\n'+
		'output_dim    = 10\n'+
		'init_min      = 0\n'+
		'init_max      = 0.1\n'+
		'iterations    = 1000\n'+
		'batch_size    = 100\n'+
		'\n'+
		'iteration_log_frequency = 100\n'+
		'\n'+
		'num_data = None\n'+
		'\n'+
		'inputs      = tf.placeholder(tf.float32, [num_data, input_dim])\n'+
		'\n'+
		'weights     = tf.Variable(tf.random_uniform([input_dim, output_dim], init_min, init_max))\n'+
		'biasses       = tf.Variable(tf.random_uniform([output_dim], init_min, init_max))\n'+
		'    \n'+
		'outputs     = tf.nn.softmax(tf.add(tf.matmul(inputs, weights), biasses))\n'+
		'labels      = tf.placeholder(tf.float32, [num_data, 10])\n'+
		'\n'+
		'cost       = tf.reduce_mean(-tf.reduce_sum(tf.multiply(labels, tf.log(outputs)), axis = 1))\n'+
		'\n'+
		'init       = tf.global_variables_initializer()\n'+
		'train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cost)\n'+
		'\n'+
		'session = tf.InteractiveSession()\n'+
		'\n'+
		'print(\'initializing.\')\n'+
		'session.run(init)\n'+
		'\n'+
		'for i in range(iterations):\n'+
		'    if i % iteration_log_frequency == 0:\n'+
		'        print(\'iteration {0}...\'.format(i))\n'+
		'        \n'+
		'    batch_input, batch_label = mnist.train.next_batch(batch_size)\n'+
		'    # note the use of vectorization and putting 2 matrices to multiple together\n'+
		'    session.run(train_step, {inputs: batch_input, labels: batch_label})\n'+
		'\n'+
		'print(\'training complete.\')\n'+
		'\n'+
		'predictions = tf.argmax(outputs, 1)\n'+
		'accuracies  = tf.reduce_mean(tf.cast(tf.equal(predictions, tf.argmax(labels, 1)), tf.float32))\n'+
		'\n'+
		'print(\'accuracy: {0}\'.format(\n'+
		'    session.run(\n'+
		'        accuracies,\n'+
		'        {inputs: mnist.test.images, labels: mnist.test.labels}\n'+
		'    )\n'+
		'))\n'+
		'\n'+
		'def predict(input):\n'+
		'    result = session.run(outputs, {inputs: [input]})[0].tolist()\n'+
		'    winner = 0\n'+
		'    curmax = 0\n'+
		'    for i in range(1, len(result)):\n'+
		'        if result[i] > curmax:\n'+
		'            winner = i\n'+
		'            curmax = result[i]\n'+
		'        \n'+
		'    return result, winner\n'+
		'\n'+
		'def flatten(array):\n'+
		'    result = []\n'+
		'    for row in array:\n'+
		'        result += row\n'+
		'    \n'+
		'    return result\n'+
		'\n'+
		'def print_with_index(array):\n'+
		'    for i in range(len(array)):\n'+
		'        print(\'{0}:\t{1} {2}\'.format(i, visualize_float(array[i]), array[i]))\n'+
		'    \n'+
		'    \n'+
		'\n'+
		'def visualize_float(x, length = 16):\n'+
		'    steps = round(x * length)\n'+
		'    return \'-\' * steps + \' \' * (length - steps)\n'+
		'\n'+
		'x = [[0 for j in range(input_dim_raw)] for i in range(input_dim_raw)]\n'+
		'_ = 0\n'+
		'x = [\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,1,1,1,1,1,1,1,1,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,1,1,1,1,1,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,1,1,1,1,1,1,1,1,1,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],\n'+
		'    [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]\n'+
		']\n'+
		'\n'+
		'result, winner = predict(flatten(x))\n'+
		'print_with_index(result)\n'+
		'print(\'prediction: {0}\'.format(winner))\n'+ ''
		
		cache_node_temps()
        
        var lines = [
            'import math, os', 
            'import tensorflow as tf', 
            'feed_dict = {}', 
            'session = tf.InteractiveSession()', 
        ]
		
        extend_array(lines, node.get_execution())
        
        script = lines.join('\n')
		
        if (!Native.is_python_running()) {
            console_dialog.clear()
            console_dialog.add_text(script)
            console_dialog.add_text('\n')
            Native.run_python(script)
        }

		console_dialog.open()
	}
    
    function cache_node_temps() {
        var count = 0
        for (var i in nodes) {
            var node = nodes[i]
            node.temp_names = []
            for (var j in node.definition.outputs) {
                node.temp_names.push('node_' + count + '_' + j)
            }
            node.temp_declared = false
			count++
        }
        for (var i in nodes) {
            var node = nodes[i]
            node.temp_params = {}
            for (var j in node.input_values) {
                var param = {}
                var input_definition = node.definition.inputs[j]
                var input_value = node.input_values[j]
                var connection = node.connections[j]
                
                if (input_definition.type === 'code' || input_definition.type === 'number' || input_definition.type === 'type') {
                    param['code_str'] = input_value
                    param['value'] = input_value
                }
                else if (input_definition.type === 'string') {
                    if (input_definition.code === 'name' && input_value.length === 0) {
                        input_value = 'node'
                    }
                    param['code_str'] = '\'' + input_value + '\''
                    param['value'] = input_value
                }
                else if (input_definition.type === 'reference') {
                    if (connection === null) {
                        param['code_str'] = 'None'
                    }
                    else {
                        param['code_str'] = connection.from_node.temp_names[connection.from_index]
                    }
                    param['value'] = connection
                }
                
                node.temp_params[input_definition.code] = param
            }
        }
    }
    
    function remove_graph_node(node) {
        for (var i in node.connections) {
            node.remove_connection(i)
        }
        var index
        for (var i in nodes) {
            var _node = nodes[i]
            if (_node === node) {
                index = i
                continue
            }
            for (var j in _node.connections) {
                if (_node.connections[j] !== null && _node.connections[j].from_node === node) {
                    _node.remove_connection(j)
                }
            }
        }
        
        nodes.splice(index, 1)
        
        node.destroy()
    }
	
	function remove_all_nodes() {
		while (nodes.length > 0) {
			remove_graph_node(nodes[0])
		}
	}
	
	function start_dragging_connection(from_node, from_index) {
		dragging_connection.from_node  = from_node
		graphDisplay.from_node         = from_node
        graphDisplay.from_index        = from_index
		dragging_mouse_area.from_point = from_node.get_output_point(from_index)
		dragging_mouse_area.dragging   = true
	}
	
	function end_dragging_connection(to_node, to_index) {
        to_node.set_connection(from_node, from_index, to_index)
	}
    
    function add_connection_visual(from_node, from_index, to_node, to_index) {
        return connection_component.createObject(
            view,
            {
                'from_node': from_node,
                'from_index': from_index,
                'to_node': to_node,
                'to_index': to_index,
            }
        )
    }
    
    Component.onCompleted: {
        
    }
	
	MouseArea {
        anchors.fill: parent
        drag.target: view
		
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		
		onWheel: function (event) {
			var old_scale = view_scale
			view_scale = clamp(view_scale + event.angleDelta.y / 360.0 * view_scale_rate, view_scale_min, view_scale_max)
			view.x = lerp(event.x, view.x, view_scale / old_scale)
			view.y = lerp(event.y, view.y, view_scale / old_scale)
		}
		
		onClicked: function (event) {
            if (event.button === Qt.RightButton) {
                right_click_menu.open()
                right_click_menu.x = event.x - 10
                right_click_menu.y = event.y - 10
				
				last_right_click_x = (event.x - offset_x) / view_scale;
				last_right_click_y = (event.y - offset_y) / view_scale;
                return
            }
        }
    }
    
    Item {
        id: view
        width: 100
        height: 100
		
		transform: Scale {
			xScale: view_scale
			yScale: view_scale
		}
		
		Connection {
            id: dragging_connection
            visible: false
            enabled: visible
		}
    }
    
	MouseArea {
		id: dragging_mouse_area
		enabled: true
		anchors.fill: parent
		propagateComposedEvents: true
		hoverEnabled: dragging
        property var from_point: null
		property bool dragging: false
        property real last_click_x: 0
        property real last_click_y: 0
		
		onDraggingChanged: {
			if (dragging) {
				
				dragging_connection.visible = true
				dragging_connection.canvas_rect = dragging_connection.get_canvas_rect(
							from_point, {x: last_click_x, y: last_click_y})
				entered({accepted: true})
			}
			else {
				
			}
		}
		
		onPressed: function (event) {
			last_click_x = (event.x - offset_x) / view_scale;
			last_click_y = (event.y - offset_y) / view_scale;
			if (!dragging) {
				target_set = false
				event.accepted = false
			}
			else {
				dragging_connection.visible = dragging = false
				target_set = true
				event.accepted = false
			}
		}
		
		onReleased: {
			
		}
		
		onPositionChanged: function (event) {
			if (dragging) {
				dragging_connection.canvas_rect = dragging_connection.get_canvas_rect(
							from_point, {
								x: (event.x - offset_x) / view_scale,
                                y: (event.y - offset_y) / view_scale,
							})
			}
			event.accepted = false;
		}
	}
	
	Menu {
		id: right_click_menu
		y: 0

		MenuItem {
			text: qsTr('New...')
			
			onTriggered: {
				new_node_dialog.open()
			}
		}
	}
	
	NewNodeDialog {
		id: new_node_dialog
	}
	
	CodeEditDialog {
		id: code_edit_dialog
	}
	
	ConsoleDialog {
		id: console_dialog
	}
}
