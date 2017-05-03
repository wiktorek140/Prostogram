import QtQuick 2.0

Rectangle {
    id: image

    property var item

    width: parent.width
    anchors{
        left: parent.left
        right: parent.right
    }

    color: "transparent"

    MainItemLoader{
        id: mainLoader
        anchors.fill: parent
        width: parent.width

        clip: true

        autoVideoPlay: false
        isSquared: true
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:item});
        }
    }
}
