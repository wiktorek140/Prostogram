import QtQuick 2.0
import Sailfish.Silica 1.0

Image {
    id: clickIcon

    signal clicked

    fillMode: Image.PreserveAspectFit

    sourceSize.width: width
    sourceSize.height: height

    MouseArea{
        id: clickMouseArea
        anchors.fill: parent
        onClicked: {
            clickIcon.clicked()
        }
    }
}
