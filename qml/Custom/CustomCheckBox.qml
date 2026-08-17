import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
CheckBox {
    property color inDicatorBoxColor: "lightgrey"
    property color inDicatorBorderColorChecked: "lightgrey"
    property color inDicatorBorderColorUnChecked: "lightgrey"
    property url checkMarkSource: "qrc:/Icons/Path.png"
    property real indicatorWidth: 26
    property real indicatorHeight: 26
    id: control
    text: qsTr("CheckBox")
    checked: false

    indicator: Rectangle {
        implicitWidth: indicatorWidth
        implicitHeight: indicatorHeight
        color:inDicatorBoxColor
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: indicatorWidth/2
        border.color: control.down ? inDicatorBorderColorChecked : inDicatorBorderColorUnChecked

        Image {
            source: checkMarkSource
            anchors.centerIn: parent
            visible: control.checked
        }
    }

    contentItem: Text {
        //text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#17a81a" : "#21be2b"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
