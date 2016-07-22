import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: galleryPage

    property string image_url

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + header.height
        contentWidth: parent.width

        PageHeader {
            id: header
            title: qsTr("Send picture")
        }

        Column {
            id: column
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Image {
                id: sendPhoto
                source: image_url
                width: parent.width

                fillMode: Image.PreserveAspectFit

                IconButton {
                    id: rotateLeft
                    icon.source: "image://theme/icon-m-refresh?" + (pressed
                                 ? Theme.highlightColor
                                 : Theme.primaryColor)
                    anchors{
                        top: parent.top
                        topMargin: rotateLeft.height/3
                        left: galleryPage.left

                    }
                    transform: Rotation { axis { x: 0; y: 1; z: 0 } angle: 180 }
                    z:2
                    x: rotateLeft.height/3*3.5

                    onClicked: {
                        instagram.rotateImg(galleryPage.image_url,-90);
                    }
                }

                IconButton {
                    id: rotateRight
                    icon.source: "image://theme/icon-m-refresh?" + (pressed
                                 ? Theme.highlightColor
                                 : Theme.primaryColor)
                    anchors{
                        top: parent.top
                        topMargin: rotateRight.height/3
                        right: parent.right
                        rightMargin: rotateRight.height/3
                    }
                    z: 2

                    onClicked: {
                        instagram.rotateImg(galleryPage.image_url,90);
                        console.log("rot")
                    }
                }
            }

            TextField{
                id: caption
                anchors{
                    top:sendPhoto.bottom
                    left: parent.left
                }
                width: parent.width
            }

            Button{
                id: sendButton
                anchors{
                    top:caption.bottom
                    left: parent.left
                }
                width: parent.width
                text: qsTr("Send photo")

                onClicked: {
                    instagram.postImage(image_url,caption.text);
                    bisy.running = true
                }
            }
        }
    }

    BusyIndicator {
        id: bisy
        anchors.centerIn: galleryPage
        running: false
    }

    Connections{
        target: instagram
        onImageConfigureDataReady:{
            console.log(answer)
            pageStack.push(Qt.resolvedUrl("StartPage.qml"));
        }
    }
}
