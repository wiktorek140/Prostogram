import QtQuick 2.0

//Reworked

Rectangle {
    property string url
    width: parent.width
    height: parent.height
    color: settings.backgroundColor()
    Image {
        id: mainImage
        anchors.fill: parent
        source: url;
    }
}
