import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: notifyItem
    width: parent.width
    height: parent.width/5

    Image {
        id: userCover
        source: args.profile_image

        width: parent.height
        height: parent.height

        fillMode: Image.PreserveAspectFit

        anchors{
            top: parent.top
            left: parent.left
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                instagram.getUsernameInfo(args.links[0].id);
            }
        }
    }

    Label {
        id: notifyText
        anchors.left:  userCover.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.right: (type === 1) ? mediaImage.left : parent.right
        anchors.rightMargin: Theme.paddingMedium
        anchors.top: parent.top
        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.highlightColor

        linkColor: Theme.highlightColor
        text: args.text
    }

    Image{
        id: mediaImage
        visible: (type === 1) ? true : false
        source: (type === 1) ? args.media[0].image : ""

        width: parent.height
        height: parent.height

        fillMode: Image.PreserveAspectFit

        anchors{
            top: parent.top
            right: parent.right
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                instagram.infoMedia(args.media[0].id);
                notifyBisy.running = true
            }
        }
    }
}

