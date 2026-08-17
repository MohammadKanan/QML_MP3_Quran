import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Button {
    id: customTextButton

    property bool isActive: true
    property color rectColor: "transparent"
    property real buttonradius: 0
    property real buttonBorderWidth: 0
    property color buttonBorderColor: "lightblue"
    property url imageSource: ""
    property size imageSize: Qt.size(width, height)
    scale: (pressed && isActive) ? 1.2 : 1

    background: Rectangle {
        id: customTextButtonRect

        radius: buttonradius
        color: customTextButton.pressed ? rectColor : "transparent"
        border.width: customTextButton.pressed && isActive ? 2 : buttonBorderWidth
        border.color: buttonBorderColor
        Image {
            source: imageSource
            sourceSize: imageSize
        }
    }

}

