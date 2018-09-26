import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property var item;

    id: likesItem
    width: parent.width
    height: parent.width/5

    Image {
        id: userCover
        source: item.profile_pic_url

        width: parent.height
        height: parent.height

        fillMode: Image.PreserveAspectFit

        anchors{
            top: parent.top
            left: parent.left
        }
    }

    Label {
        id: notifyText
        anchors.left:  userCover.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.rightMargin: Theme.paddingMedium
        anchors.top: parent.top
        wrapMode: Text.Wrap
        font.pixelSize: settings.small
        color: Theme.highlightColor

        linkColor: Theme.highlightColor
        text: (item.full_name) ? item.full_name : item.username
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../pages/UserProfilPage.qml"),{user: item});
        }
    }
}

