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
                    id: configButton
                    icon.source: "image://theme/icon-m-edit?" + (pressed
                                 ? Theme.highlightColor
                                 : Theme.primaryColor)
                    anchors{
                        top: parent.top
                        topMargin: configButton.height/3
                        right: parent.right
                        rightMargin: configButton.height/3
                    }
                    z: 2

                    onClicked: {
                        pageStack.push(Qt.resolvedUrl(
                                        "EditPhotoPage.qml"), {
                                        image_url: image_url
                                     })
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
                    instagram.postImage(image_url.replace("file://",""),caption.text);
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
