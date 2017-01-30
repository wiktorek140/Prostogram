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
            width: parent.width

            Image {
                id: sendPhoto
                source: image_url
                width: parent.width

                fillMode: Image.PreserveAspectFit
            }

            TextField{
                id: caption
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: {
                    focus = false
                    instagram.postImage(image_url.replace("file://",""),caption.text);
                    bisy.running = true
                }
            }

            Button{
                id: sendButton
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
            pageStack.replace(Qt.resolvedUrl("StartPage.qml"));
        }
    }
}
