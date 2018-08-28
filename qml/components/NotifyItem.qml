import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

//reworked

Item {
    id: notifyItem
    width: parent.width
    height: width * 0.2

    clip: true

    Image {
        id: userCover
        source: args.profile_image

        width: parent.height * 0.8
        height: parent.height * 0.8

        fillMode: Image.PreserveAspectFit

        anchors {
            topMargin: 10
            bottomMargin: 10
            top: parent.top
            left: parent.left
            verticalCenter: notifyItem.verticalCenter
        }
        layer.enabled: true
        layer.effect: OpacityMask {
            anchors.fill: userCover
            maskSource: Rectangle {
                width: userCover.height
                height: userCover.height
                radius: width
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                instagram.getInfoById(args.links[0].id);
            }
        }
    }



    Label {
        id: notifyText
        anchors {
            left:  userCover.right
            leftMargin: Theme.paddingMedium
            right: (type === 1) ? mediaImage.left : parent.right
            rightMargin: Theme.paddingMedium
            top: parent.top
        }

        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeExtraSmall

        color: "black"
        linkColor: "navy"
        text: args.text
    }

    Image {
        id: mediaImage
        visible: (type === 1) ? true : false
        source: (type === 1) ? imageCache.getFromCache2(args.media[0].image) : ""

        width: parent.height * 0.9
        height: parent.height * 0.9

        fillMode: Image.PreserveAspectFit

        anchors {
            top: parent.top
            right: parent.right
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                instagram.getInfoMedia(args.media[0].id);
                notifyBusy.running = true
            }
        }
    }
}

