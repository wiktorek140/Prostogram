import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: editPhotoPage

    property string image_url
    property bool squared

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + header.height
        contentWidth: parent.width

        PageHeader {
            id: header
            title: qsTr("Edit photo")
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
            }
        }
    }
}
