import QtQuick
import QtQuick.Controls
import QtMultimedia
import "./qml/Custom"

Item {
    id: _itm
    property real sliderStoredValue: 0.9
    property bool soundDisabled: false
    MediaPlayer {
        id: playerQuran
        //source: "https://server11.mp3quran.net/shatri/001.mp3"
        source: "https://audio-samples.github.io/samples/mp3/music/sample-2.mp3"
        audioOutput: AudioOutput {
            volume: slider.value
        }
        Component.onCompleted: _itm.playAudio()
    }
    Timer{
        id: checkTimer
        interval: 9 * 1000
        running: false
        onTriggered: {
            playerQuran.play()
            if(playerQuran.mediaStatus === MediaPlayer.InvalidMedia)
                console.log("invalid media", playerQuran.mediaStatus)
            else
                console.log("The player status :" , playerQuran.mediaStatus)
            console.log("Timer ..., player status :" , playerQuran.mediaStatus === MediaPlayer.BufferedMedia ? "MediaPlayer.Buffered" :  playerQuran.mediaStatus , playerQuran.playing)
        }
    }

    Row{
        spacing: 20
        anchors{
            top: parent.top
            topMargin: 80
            left: parent.left
            leftMargin: 50
        }
        CustomImageButton{
            width: 40
            height: width
            imageSource: "qrc:/qml/Icons/playVideo.png"
            onPressed: playerQuran.play()
        }
        CustomImageButton{
            width: 40
            height: width
            imageSource: "qrc:/qml/Icons/pause.png"
            onPressed: playerQuran.pause()
        }
        CustomImageButton{
            width: 40
            height: width
            imageSource:  "qrc:/qml/Icons/stop_Video.png"
            onPressed: playerQuran.stop()
        }
    }

    CustomImageButton{
        id: volumeImage
        width: 40
        height: width
        imageSource: soundDisabled ? "qrc:/qml/Icons/volume_off.png" : "qrc:/qml/Icons/volume_on.png"
        anchors{
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 50
        }
        onPressed: {
            if(soundDisabled){
                soundDisabled = false
            }
            else{
                sliderStoredValue = slider.value
                soundDisabled = true
            }
        }
    }
    Slider {
        id: slider
        anchors{
            top: parent.top
            topMargin: 30
            left: volumeImage.right
            leftMargin: 20
        }
        from: 0.
        to: 1.
        value: soundDisabled ? 0 : sliderStoredValue
    }
    ListView {
        id: viewer
        width: 200; height: parent.height
        anchors{
            top: slider.bottom
            topMargin: 50
            horizontalCenter: parent.horizontalCenter
        }
        model: quranModel
        delegate: Rectangle{
            height: 50
            width: 200
            radius: 16
            color: index === viewer.currentIndex ? "yellow" : "transparent"
            opacity: index === viewer.currentIndex ? 0.5 : 1
            border{
                width: 0
                color: "black"
            }

            Row{
                anchors.centerIn: parent
                spacing: 20
                Label{
                    width: 100
                    text: SoraNumber //+ " - "
                    font{
                        pixelSize: 20
                    }
                }

                Label{
                    width: 100
                    text: SoraName
                    //color: ma.entered ? "green" : "#000000"
                    font{
                        pixelSize: 20
                    }
                }
            }
            MouseArea{
                id:ma
                enabled: true
                anchors.fill: parent
                hoverEnabled: true
                onReleased: {
                    //parent.color = "yellow"
                    viewer.currentIndex = index
                    //parent.opacity = 0.5
                    //console.log("path:" , fileURL)
                    playerQuran.source = constructURL(SoraNumber)
                    playAudio()
                }
            }

        }
        Component.onCompleted: currentIndex = -1
    }
    function playAudio(){
        //playerQuran.play()
        checkTimer.start()
    }
    function constructURL(index){
        var url = "https://server11.mp3quran.net/shatri/"// "https://server11.mp3quran.net/shatri/"
        url += index
        url += ".mp3"
        console.log("player url :" , url)
        return url
    }
}
