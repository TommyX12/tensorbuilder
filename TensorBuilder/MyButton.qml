import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    id: root
    
    //property bool customColor: false;
    
    property color buttonColor: "#eeeeee"
    
    property color idleColor
    property color hoverColor
    property color pressedColor
    
    property color currentColor
    property color borderColor
    property color textColor
    /*
    property color disabledColor//: "#cccccc"
    property color disabledBorderColor//: "#888888"
    property color disabledTextColor//: "#888888"
    */
    property color disabledColor: Qt.tint(currentColor, disabledTinting);
    property color disabledBorderColor: Qt.tint(borderColor, disabledTinting);
    property color disabledTextColor: Qt.tint(textColor, disabledTinting);
    
    property color disabledTinting: "#88888888";
    
    property real idleBorderWidth: 1
    property real hoverBorderWidth: 2
    property real pressedBorderWidth: 1.5
    
    enabled: visible
    
    height: 20
    
    Behavior on color {
        id: colorAnimation
        ColorAnimation{duration: 60; easing.type: Easing.Linear}
    }
    
    property alias text: txt.text;
    property alias label: txt;
    
    function autoRefreshColor() {
        //if (customColor) return;
        
        var _hsl = main.hsl(buttonColor.r, buttonColor.g, buttonColor.b);
        var luma = main.luma(buttonColor.r, buttonColor.g, buttonColor.b);
        
        textColor = luma > 0.6 ? "#ff000000" : "#ffffffff";
        
        var hsl = {h:_hsl.h, s:_hsl.s, l:_hsl.l};
        hsl.l = luma > 0.5 ? hsl.l - 0.2 : hsl.l + 0.3;
        hsl.s *= 0.75;
        borderColor = Qt.hsla(hsl.h, hsl.s, hsl.l, 1.0);
        
        idleColor = buttonColor;
        
        hsl = {h:_hsl.h, s:_hsl.s, l:_hsl.l};
        
        hoverColor = idleColor;
        //if (hsl.l < 0.25) {
            /*
            hoverColor.r = 1.0 - (1.0 - idleColor.r) * 0.8;
            hoverColor.g = 1.0 - (1.0 - idleColor.g) * 0.8;
            hoverColor.b = 1.0 - (1.0 - idleColor.b) * 0.8;
            //*/
            //hoverColor = Qt.hsla(hsl.h, hsl.s, 1.0 - (1.0 - hsl.l) * 0.8, 1.0);
            //hoverColor = Qt.hsla(hsl.h, hsl.s, hsl.l + 0.2, 1.0);
        //}
        /*
        hoverColor.r *= 1.2;
        hoverColor.g *= 1.2;
        hoverColor.b *= 1.2;
        */
        //else {
            /*
            hoverColor.r += 0.1;
            hoverColor.g += 0.1;
            hoverColor.b += 0.1;
            //*/
        //}
        hoverColor = Qt.hsla(hsl.h, hsl.s, hsl.l + 0.1, 1.0);
        
        pressedColor = idleColor;
        /*
        pressedColor.r *= 0.9;
        pressedColor.g *= 0.9;
        pressedColor.b *= 0.9;
        */
        pressedColor = Qt.hsla(hsl.h, hsl.s, hsl.l - 0.05, 1.0);
        
        if (hsl.l > 0.95) {
            var _r = pressedColor.r;
            var _g = pressedColor.g;
            var _b = pressedColor.b;
            pressedColor = hoverColor;
            hoverColor.r = _r;
            hoverColor.g = _g;
            hoverColor.b = _b;
        }
        
        visualEventHandler();
    }
    
    function visualEventHandler () {
        if (mouse.pressed) {
            root.currentColor = root.pressedColor
            root.border.width = root.pressedBorderWidth
        }
        else if (mouse.containsMouse){
            root.currentColor = root.hoverColor
            root.border.width = root.hoverBorderWidth
        }
        else {
            root.currentColor = root.idleColor
            root.border.width = root.idleBorderWidth
        }
    }
    
    onButtonColorChanged: function (){
        colorAnimation.enabled = false;
        autoRefreshColor();
        colorAnimation.enabled = true;
    }
    
    Component.onCompleted: {
        autoRefreshColor();
    }
    
    color: enabled ? currentColor : disabledColor
    border.color: enabled ? borderColor : disabledBorderColor
    
    signal clicked(var button);
    
    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onClicked: root.clicked(root);

        onContainsMouseChanged: root.visualEventHandler()
        onPressedChanged: root.visualEventHandler()

        onPositionChanged: {
            
        }
    }
    
    Label {
        id: txt
        text: root.text
        color: root.enabled ? textColor : disabledTextColor;
		font.bold: true
        anchors.centerIn: parent;
    }
}
