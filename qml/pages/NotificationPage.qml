import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: notificationPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + header.height
        contentWidth: parent.width

        PageHeader {
            id: header
            title: qsTr("Noitifications")
        }
    }
}

