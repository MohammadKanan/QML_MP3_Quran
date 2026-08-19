import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "./"

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Quran")
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"
    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...")
                onTriggered: {theControl.newDialog.open(); theImage.visible = true}
            }
            MenuSeparator { }
            Action { text: qsTr("&Quit")
                onTriggered: close()
            }
        }
        Menu {
            title: qsTr("&Edit")

            Action { text: qsTr("&Settings")
                onTriggered: function(){
                    //sizeSelectLOader.sourceComponent = sizeEntryComp
                    //sizeSelectLOader.source = "src/Settings_Manager.qml"
                    settingsPopup.open()
                }
            }

        }
        Menu {
            title: qsTr("Show")
            Action {
                text: qsTr("Show Sora while reading")
                onTriggered: function(){
                    play_Ground_Loader.active=false
                    play_Ground_Loader.visible = false
                    theImage.visible=true
                }
            }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }
    Player{
        id: quranPlayer
        anchors.fill: parent
    }
}
