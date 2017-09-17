import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    id:container
    width: 320
    height: 480

	anchors.fill: parent
	anchors.topMargin: 12
	
	property var from_node: null
	property int from_index: 0
	
	property var to_node: null
	property int to_index: 0
	
	property var canvas_rect: {
		return get_canvas_rect(from_node.get_output_point(from_index), to_node.get_input_point(to_index))
	}
	
	function get_canvas_rect(from_point, to_point) {
        var rect_x      = Math.min(from_point.x, to_point.x)
        var rect_y      = Math.min(from_point.y, to_point.y)
		var rect_width  = Math.max(from_point.x, to_point.x) - rect_x
		var rect_height = Math.max(from_point.y, to_point.y) - rect_y
        rect_width = Math.max(10, rect_width)
        rect_height = Math.max(10, rect_height)
        
        return {
            'x': rect_x,
            'y': rect_y,
            'width': rect_width,
            'height': rect_height,
            'start_x': (from_point.x - rect_x) / rect_width,
            'start_y': (from_point.y - rect_y) / rect_height,
			'end_x': (to_point.x - rect_x) / rect_width,
            'end_y': (to_point.y - rect_y) / rect_height,
        }
	}
	
	Component.onCompleted: {
		
	}

	Canvas {
		id: canvas
        width: Math.min(canvas_rect.width / canvas_rect.height * 512, 512)
        height: Math.min(canvas_rect.height / canvas_rect.width * 512, 512)
		x: canvas_rect.x
		y: canvas_rect.y
		property color strokeStyle: from_node.definition.color
		property real lineWidth: 4.0 / Math.min(scaleX, scaleY)
		property bool fill: true
		property bool stroke: true
		property real scaleX: canvas_rect.width / width
		property real scaleY: canvas_rect.height / height
		antialiasing: true

		onFillChanged:requestPaint();
		onStrokeChanged:requestPaint();
		onScaleXChanged: requestPaint();
		onScaleYChanged: requestPaint();
		
        transform: Scale {
            xScale: canvas.scaleX
            yScale: canvas.scaleY
        }
        
		function draw_bezier(ctx, start_x, start_y, end_x, end_y) {
            start_x *= width
            start_y *= height
            end_x *= width
            end_y *= height
			ctx.moveTo(start_x, start_y);
			ctx.bezierCurveTo(lerp(start_x, end_x, 0.5), start_y, lerp(start_x, end_x, 0.5), end_y, end_x, end_y);
		}

		onPaint: {
			var ctx = canvas.getContext('2d');
			ctx.save();
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			ctx.strokeStyle = canvas.strokeStyle;
			ctx.fillStyle = canvas.fillStyle;
			ctx.lineWidth = canvas.lineWidth;

			ctx.beginPath();
			draw_bezier(ctx, canvas_rect.start_x, canvas_rect.start_y, canvas_rect.end_x, canvas_rect.end_y)
			if (canvas.stroke)
				ctx.stroke();
			ctx.restore();
		}
	}
}
