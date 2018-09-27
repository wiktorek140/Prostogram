import QtQuick 2.0

//reworked

Rectangle {
    property var url

    id: carusel
    width: parent.width
    height: parent.height
    //z: 0


    ListView {
        id: caruselListView
        width: parent.width
        height: parent.height
        model: url

        orientation: Qt.Horizontal
        //focus: true

        snapMode: ListView.SnapOneItem

        //move: Transition {
        //    NumberAnimation { properties: "x"; duration: 1000 }
        //}

        delegate: Image {
            //z:1
            property string path: imageCache.getFromCache(image_versions2.candidates[0].url);
            property bool isDownloaded: false


            id: dImage
            width: carusel.width
            //source: image_versions2.candidates[0].url;
            fillMode: Image.PreserveAspectFit

            onStatusChanged: {
                if(status === Image.Ready) {
                    if(isDownloaded) {
                        dImage.grabToImage(function(result) {
                                                    print("Save to path:" + path);
                                                   result.saveToFile(path);
                                               });
                    }
                }
            }

            Timer {
                id: poke
                interval: 10;
                running: true;
                repeat: false;
                onTriggered: {
                    if(imageCache.isFileDownloaded(path)) {
                        dImage.source = path;
                        isDownloaded = false;
                    }
                    else {
                        dImage.source = image_versions2.candidates[0].url;
                        isDownloaded = true;
                    }

                    //height = (width/mainImage.sourceSize.width) * mainImage.sourceSize.height
                    //mainImage.sourceSize.height = height
                    //mainImage.sourceSize.width = width
                    dImage.update();
                }
            }
        }

        Timer {
            id:timer
            interval: 5000
            running: false
            repeat: true
            onTriggered: {
                if(caruselListView.currentIndex == caruselListView.count-1)
                {
                    caruselListView.currentIndex = 0
                }
                else
                {
                    caruselListView.currentIndex++
                }
            }
        }

        Image {
            source: "../images/carusel.svg"
            width: parent.width/20
            height: parent.width/20

            sourceSize.height: height
            sourceSize.width: height

            anchors {
                left: parent.left
                leftMargin: parent.width/25
                bottom: parent.bottom
                bottomMargin: parent.width/25
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //carusel.z = -1
                if(feedItemArea.z === 1 ) feedItemArea.z = 0;
                else { feedItemArea.z = 1; feedItemArea.lClick = Date.now();}
            }
        }
    }
}
