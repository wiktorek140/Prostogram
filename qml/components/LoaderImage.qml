import QtQuick 2.0
//import harbour.prostogram.cache 1.0
//import harbour.prostogram.saver 1.0
import Sailfish.Silica 1.0

//Reworked
Rectangle {
    property string url
    property string path
    property bool isDownloaded: false

    width: parent.width
    anchors.top: parent.top
    color: settings.backgroundColor()

    BusyIndicator {
        id: loadImage
        visible: true
        anchors.fill: parent
        anchors.centerIn: parent
        running: true
    }

    Component.onCompleted: {
        path = imageCache.getFromCache(url);
        poke.restart();
    }


    Image {
        id: mainImage
        width: parent.width
        anchors.top: parent.top
        fillMode: Image.PreserveAspectFit
        visible: false

        onStatusChanged: {
            if(mainImage.status === Image.Error || mainImage.status === Image.Loading) {
                loadImage.visible = true;
            }

            if(mainImage.status === Image.Ready) {
                loadImage.visible = false;
                mainImage.visible = true;

                if(isDownloaded) {
                    mainImage.grabToImage(function(result) {
                                                print("Save to path:"+path);
                                                result.saveToFile(path);
                                           });
                }
            }
        }
    }

    Timer {
        id: poke
        interval: 1000
        running: false;
        repeat: false;
        onTriggered: {
            if(imageCache.isFileDownloaded(path)) {
                mainImage.source = path;
                isDownloaded = false;
            }
            else {
                mainImage.source = url;
                isDownloaded = true;
            }

            height = (width/mainImage.sourceSize.width) * mainImage.sourceSize.height
            mainImage.sourceSize.height = height
            mainImage.sourceSize.width = width
            mainImage.update();
        }
    }
}
