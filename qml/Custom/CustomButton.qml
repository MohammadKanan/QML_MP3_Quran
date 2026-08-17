import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Button {
    id: customTextButton

    property bool isActive: true
    property string buttonText: ""
    property color rectColor: "transparent"
    property color textcolor: "#000000"
    property real buttonradius: 0
    property real buttonBorderWidth: 0
    property color buttonBorderColor: "lightblue"
    text: buttonText
    scale: (pressed && isActive) ? 1.2 : 1

    contentItem: Text {
        text: customTextButton.text
        font: customTextButton.font
        opacity: enabled ? 1 : 0.3
        color: textcolor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        id: customTextButtonRect

        radius: buttonradius
        color: customTextButton.pressed ? rectColor : "transparent"
        border.width: customTextButton.pressed && isActive ? 2 : buttonBorderWidth
        border.color: buttonBorderColor
    }

}

