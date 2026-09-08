import QtQuick
import QtQuick.Controls
import QtMultimedia
import "./qml/Custom"

Item {
    id: _itm
    property real sliderStoredValue: 0.05
    property bool soundDisabled: false
    property bool downloading: false
    property int readerID: 0
    signal loadNextSora()

    Connections{
        target: networkDownloader
        function onDownloadFinished(){
            _itm.downloading = false
        }
    }

    Rectangle{
        anchors.fill: parent
        color: "beige"
    }

    MediaPlayer {
        id: playerQuran
        property bool mediaValid: true
        property bool infinit: false
        property bool contineous: false
        property string sora: ""
        property real latestPosition: 0
        //source: "https://server11.mp3quran.net/shatri/002.mp3"
        //source: "https://audio-samples.github.io/samples/mp3/music/sample-2.mp3"
        loops: playerQuran.infinit ? MediaPlayer.Infinite : 1
        onPositionChanged:{
            //console.log("Current position (ms): " + playerQuran.position + "/" + playerQuran.duration)
            latestPosition = 100 * (playerQuran.position / playerQuran.duration)
        }
        onMediaStatusChanged:{
            if (mediaStatus === MediaPlayer.EndOfMedia && contineous){
                console.log("Media finished .....................!!!!")
                _itm.loadNextSora()
                console.log("Now is : " , "'" , sora, "'")
                var soraNumNext = Number(sora) + 1
                if(soraNumNext === 115)
                    soraNumNext = 1
                var nextSora = "" + soraNumNext
                while(nextSora.length < 3){
                    nextSora = "0" + nextSora
                }
                console.log("length is ............................" , nextSora.length)
                playerQuran.sora = nextSora
                playerQuran.source = constructURL(nextSora)
                playerQuran.play()
            }
        }

        audioOutput: AudioOutput {
            volume: slider.value
        }
        Component.onCompleted: {
            //playerQuran.source = constructURL(nextSora)
            sora = theSettings.sora
            playerQuran.position = theSettings.position

        }
    }
    Timer{
        id: checkTimer
        interval: 3 * 1000
        running: false
        onTriggered: {
            playerQuran.play()
            splash_Timer.start()
            if(playerQuran.mediaStatus === MediaPlayer.InvalidMedia){
                console.log("Media is : invalid media", playerQuran.mediaStatus)
                playerQuran.mediaValid = false
                playerQuran.source = constructURL(playerQuran.sora)
                playerQuran.play()
            }
            else
                console.log("The player status :" , playerQuran.mediaStatus)
            playerQuran.mediaValid = true
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
            opacity: pressed ? 0.5 :1
            onPressed: playerQuran.play()
        }
        CustomImageButton{
            width: 40
            height: width
            opacity: pressed ? 0.5 :1
            imageSource: "qrc:/qml/Icons/pause.png"
            onPressed: playerQuran.pause()
        }
        CustomImageButton{
            width: 40
            height: width
            opacity: pressed ? 0.5 :1
            imageSource:  "qrc:/qml/Icons/stop_Video.png"
            onPressed: playerQuran.stop()
        }
        CustomImageButton{
            id:loopSetter
            property real theOpacity: 1
            width: 40
            height: width
            anchors.verticalCenter: parent.verticalCenter
            opacity: theOpacity
            imageSource: "qrc:/qml/Icons/loop3.png"
            onPressed: {
                playerQuran.infinit = !playerQuran.infinit
                theOpacity = (theOpacity === 1) ? 0.4 : 1
            }
        }
        CustomImageButton{
            id:continueosSetter
            property real theOpacity: 1
            width: 40
            height: width
            anchors.verticalCenter: loopSetter.verticalCenter
            anchors.verticalCenterOffset: 10
            opacity: theOpacity
            imageSource: "qrc:/qml/Icons/infinite_Read.png"
            onPressed: {
                playerQuran.contineous = !playerQuran.contineous
                theOpacity = (theOpacity === 1) ? 0.4 : 1
            }
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
             // const int _reader, const int& _sora , const QString& _soraURL, const double _position
            theSettings.saveSettings(_itm.readerID,  quranList.currentIndex + 1, playerQuran.source , playerQuran.position)
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

        spacing: 5
        ComboBox {
            id:readerCombo
            width: 180
            model: ListModel {
                id: model
                ListElement { text: "الشاطري" }
                ListElement { text: "المعصراوي" }
                ListElement { text: "عبدالباسط" }
                ListElement { text: "محمد الطبلاوي" }
                ListElement { text: "محمد صديق المنشاوي" }
            }
            background: Rectangle {
                   implicitWidth: readerCombo.width
                   implicitHeight: readerCombo.height
                   color: readerCombo.pressed ? "#e0e0e0" : "#f0f0f0"
                   border.color: "#b0b0b0"
                   border.width: 1
                   radius: 8 // Adjust this value to make corners more or less rounded
               }
            currentIndex: theSettings.reader
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
    Image {
        id: running_Splash
        property var splashArray: [""  , "qrc:/qml/Icons/Splasher/quran_1.jpeg" , "qrc:/qml/Icons/Splasher/quran_6.jpeg" , "qrc:/qml/Icons/Splasher/quran_7.jpeg" , "qrc:/qml/Icons/Splasher/quran_8.jpeg" , "qrc:/qml/Icons/Splasher/quran_5.jpeg" , "qrc:/qml/Icons/Splasher/quran_9.jpeg" , "qrc:/qml/Icons/Splasher/quran_10.jpeg" , "qrc:/qml/Icons/Splasher/1.png"]
        property int splashSlider: 0
        visible: false
        anchors.fill: _itm
        width: window.width
        height: window.height
        //fillMode: Image.TileVertically
        source: splashArray[splashSlider]
        MouseArea{
            anchors.fill: parent
            onPressed: running_Splash.visible =false
        }
    }
    Timer{
        id:splash_Timer
        running: false
        interval: 5*60*1000 //(5 minutes)
        onTriggered: function(){
            console.log("image source" , running_Splash.splashArray[running_Splash.splashSlider])
            running_Splash.visible = true
            running_Splash.splashSlider++
            if(running_Splash.splashSlider === running_Splash.splashArray.length){
                running_Splash.splashSlider = 0
            }

            splash_Timer.start()
        }
    }
    Rectangle{
        id: downloadRect
        visible: _itm.downloading
        width: 100
        height: 40
        anchors{
            top: selectReaderRow.bottom
            horizontalCenter: selectReaderRow.horizontalCenter
            topMargin: 40
        }

        color: "transparent"
        radius: 5

        Connections{
            target: networkDownloader
            function onProgressChanged(received , total){
                progressRect.width = 100 * received / total
            }
        }
        Label{
            id: downloadLbl
            text: qsTr("Downloading")
            font{
                //bold: true
                pixelSize: 15
            }
        }
        Rectangle{
            id: progressRect
            anchors{
                top: downloadLbl.bottom
                topMargin: 10
            }

            width: 0
            radius: parent.radius
            height: 20
            color: "red"
        }

    }
    Slider {
        id: soraProgress
        width: 300
        from: 0
        to: 100
        snapMode: Slider.SnapOnRelease
        value: playerQuran.latestPosition
        anchors{
            top: downloadRect.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 5
        }
        onValueChanged:{
            //console.log("current value" , soraProgress.value/100)
        }
        onMoved:{

                const aPosition = soraProgress.value
                playerQuran.setPosition(value*playerQuran.duration/100)
                //value = playerQuran.latestPosition
                console.log("current Value : " , soraProgress.value)
            }
        background: Rectangle {
            x: soraProgress.leftPadding
            y: soraProgress.topPadding + soraProgress.availableHeight / 2 - height / 2
            implicitWidth: 300
            implicitHeight: 4
            width: soraProgress.availableWidth
            height: implicitHeight
            radius: 5
            color: "#bdbebf"

            Rectangle {
                width: soraProgress.visualPosition * parent.width
                height: parent.height
                color: "#21be2b"
                radius: 5
            }
        }

        handle: Rectangle {
            visible: progressMA.isEntered
            x: soraProgress.leftPadding + soraProgress.visualPosition * (soraProgress.availableWidth - width)
            y: soraProgress.topPadding + soraProgress.availableHeight / 2 - height / 2
            z: 1
            implicitWidth: 20
            implicitHeight: 20
            radius: 10
            color: soraProgress.pressed ? "#f0f0f0" : "lightgreen"
            border.color: "#bdbebf"

        }
        MouseArea{
            id:progressMA
            z: 0
            property bool isEntered: false
            anchors.fill: soraProgress
            hoverEnabled: true
            onEntered: {isEntered = true  ; progressMA.enabled = false}
            onExited: { isEntered = false ; progressMA.enabled = true}

        }
    }

    ListView {
        id: quranList
        width: _itm.width ; height: parent.height
        //snapMode: ListView.SnapToItem
        clip: true
        anchors{
            top: downloadRect.bottom
            topMargin: 60
            //horizontalCenter: parent.horizontalCenter
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 50
        }
        Connections{
            target: _itm
            function onLoadNextSora(){
                    //console.log("current is : " , SoraNumber)
                                if (quranList.currentIndex < quranList.count - 1) {
                                    quranList.incrementCurrentIndex()
                                } else quranList.currentIndex = 0

            }
        }
        model: quranModel
        currentIndex: theSettings.sora - 1
        delegate: Rectangle{
            id: soraRect
            property bool isSelected: false
            height: 50
            width: quranList.width
            anchors.right: ListView.right
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
                    id: soraNumLbl
                    width: 100
                    text: quranList.getSoraStringIndex(SoraNumber) //+ " - "
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
                    playerQuran.sora = soraNumLbl.text
                    playerQuran.source = constructURL(playerQuran.sora)
                    //playerQuran.source = playLocalFile(SoraNumber)
                    playAudio()
                }
            }

        }
        Component.onCompleted: currentIndex = -1
        function getSoraStringIndex(soraNumber){
            var newSoraNumber = "" + soraNumber
            while(newSoraNumber.length < 3)
                newSoraNumber = "0" + newSoraNumber;
            return newSoraNumber
        }
    }
    function playAudio(){
        //playerQuran.play()
        checkTimer.start()
    }
    function constructURL(index){
        var url
        switch(_itm.readerID){
        case 0:
            url = "https://server11.mp3quran.net/shatri/"
            break
        case 1:
            url = "https://server16.mp3quran.net/a_maasaraawi/Rewayat-Hafs-A-n-Assem/"
            break
        case 2:
            url = "https://server7.mp3quran.net/basit/"
            break
        case 3:
            url = "https://server12.mp3quran.net/tblawi/Al-Mojawwad/"
            break
        case 4:
            url = "https://server10.mp3quran.net/minsh1387/"
        }
        const fileName = index + ".mp3"
        url += fileName
        //console.log("player url :" , url)
        if (!playerQuran.mediaValid){
            _itm.downloading = true;
            networkDownloader.startDownload(url, fileName , _itm.readerID)
        }else{
            const _soraFile = networkDownloader.checkSoraDownloaded(index,_itm.readerID)
            if(_soraFile === "" ) {
                console.log("Downloading Sora " + index)
                networkDownloader.startDownload(url, fileName , _itm.readerID)
                _itm.downloading = true;
            } else{
                console.log("play from local file " , _soraFile)
                url = "file:///" +  _soraFile
            }
        }
        //checkTimer.start()
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