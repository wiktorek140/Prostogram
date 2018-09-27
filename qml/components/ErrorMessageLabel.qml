import QtQuick 2.0
import Sailfish.Silica 1.0

Label {
    font.pixelSize: settings.large
    color: Theme.secondaryColor
    visible: false
    text:qsTr('An error occurred.')
    anchors.centerIn: parent
}
