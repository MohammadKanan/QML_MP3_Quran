import QtQuick
import QtQuick.Controls
import QtMultimedia
import "./qml/Custom"

Item {
    id: _itm
    property real sliderStoredValue: 0.05
    property bool soundDisabled: false
    property int readerID: 0
    Rectangle{
        anchors.fill: parent
        color: "beige"
    }

    MediaPlayer {
        id: playerQuran
        //source: "https://server11.mp3quran.net/shatri/001.mp3"
        //source: "https://audio-samples.github.io/samples/mp3/music/sample-2.mp3"
        audioOutput: AudioOutput {
            volume: slider.value
        }
        Component.onCompleted: _itm.playAudio()
    }
    Timer{
        id: checkTimer
        interval: 3 * 1000
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
        id: buttonsRow
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
        height: 50
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
    CustomImageButton{
        id: quitApp
        width: 40
        height: width
        imageSource: "qrc:/qml/Icons/quit.png"
        anchors{
            top: parent.top
            topMargin: 20
            right:  parent.right
            rightMargin: 20
        }
        onPressed: {
            close()
        }
    }
    Row{
        id:selectReaderRow
        anchors{
            right: parent.right
            rightMargin: 40
            top: buttonsRow.bottom
            topMargin: 30

        }

        spacing: 20
        Rectangle{
            id: totalRect
            width: 100
            height: 10
            anchors.verticalCenter: readerCombo.verticalCenter
            color: "transparent"
            radius: 5
            border{
                color: "blue"
                width: 1
            }

            Connections{
                target: networkDownloader
                function onProgressChanged(received , total){
                    //totalRect.width = total /10000
                    progressRect.width = 100 * received / total
                }
            }
                Rectangle{
                    id: progressRect
                    width: 0
                    height: parent.height
                    color: "red"
                }
        }
        ComboBox {
            id:readerCombo
            model: ListModel {
                id: model
                ListElement { text: "الشاطري" }
                ListElement { text: "المعصراوي" }
                ListElement { text: "عبدالباسط" }
            }
            onCurrentIndexChanged: {
                _itm.readerID = currentIndex
                console.log("Reader \n\n" , _itm.readerID)
            }
        }
        Label{
            text: "القارئ"
            width: 100
            anchors.verticalCenter: readerCombo.verticalCenter
            font{
                //bold: true
                pixelSize: 15
            }
        }
    }

    ListView {
        id: quranList
        width: _itm.width ; height: parent.height
        snapMode: ListView.SnapToItem
        clip: true
        anchors{
            top: buttonsRow.bottom
            topMargin: 100
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50
        }
        model: quranModel
        delegate: Rectangle{
            id: soraRect
            property bool isSelected: false
            height: 50
            width: quranList.width
            radius: 16
            color: index === quranList.currentIndex ? "yellow" : "transparent"
            opacity: index === quranList.currentIndex ? 0.5 : 1
            border{
                width: index === quranList.currentIndex ? 1 : 0
                color: "black"
            }

            Row{
                anchors.centerIn: parent
                spacing: 10
                Label{
                    width: 150
                    text: " وعدد آياتها - " + SoraCount
                    font{
                        //bold: true
                        pixelSize: 15
                    }
                }
                Label{
                    width: 70
                    text: SoraLocation
                    font{
                        //bold: true
                        pixelSize: 15
                    }
                }
                Label{
                    width: 80
                    text: SoraName
                    //color: ma.entered ? "green" : "#000000"
                    font{
                        bold: true
                        pixelSize: 20
                    }
                }
                Label{
                    width: 100
                    text: SoraNumber //+ " - "
                    font{
                        bold: true
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
                    soraRect.isSelected = true
                    quranList.currentIndex = index
                    //parent.opacity = 0.5
                    //console.log("path:" , fileURL)
                    playerQuran.source = constructURL(SoraNumber)
                    //playerQuran.source = playLocalFile(SoraNumber)
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
        var url
        switch(_itm.readerID){
        case 0:
            url = "https://server11.mp3quran.net/shatri/"// "https://server11.mp3quran.net/shatri/";
            break
        case 1:
            url = "https://server16.mp3quran.net/a_maasaraawi/Rewayat-Hafs-A-n-Assem/"
            break
        case 2:
            url = "https://server7.mp3quran.net/basit/"
            break
        }
        const fileName = index + ".mp3"
        url += fileName
        //url += ".mp3"
        console.log("player url :" , url)
        const _soraFile = networkDownloader.checkSoraDownloaded(index,_itm.readerID)
        if(_soraFile === "") {
            console.log("Downloading Sora " + index)
            networkDownloader.startDownload(url, fileName , _itm.readerID)
        } else{
            console.log("play from local file " , _soraFile)
            url = "file:///" +  _soraFile
        }

        return url
    }
    function playLocalFile(index){
        var url = "file:///storage/sdcard0/Quran/003.mp3"
        quranModel.checkURL(url)
        //url +=index
        //url +=".mp3"
        return url
    }
}
