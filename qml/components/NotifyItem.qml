import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

//reworked

Item {
    id: notifyItem
    width: parent.width
    height: (Theme.itemSizeSmall >= notifyText.height)? Theme.itemSizeSmall : notifyText.height

    clip: true

    Rectangle {
        id: userCover
        width: Theme.itemSizeSmall
        height: Theme.itemSizeSmall
        anchors {
            //topMargin: 10
            //bottomMargin: 10
            top: parent.top
            left: parent.left
            //verticalCenter: notifyItem.verticalCenter
        }
        color: settings.transparent()

        Image {
            id:userCoverImg
            source: args.profile_image
            width: parent.height * 0.8
            height: parent.height * 0.8
            //fillMode: Image.PreserveAspectFit
            sourceSize {
                width: width
                height: height
            }
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            layer.enabled: true
            layer.effect: OpacityMask {
                anchors.fill: userCoverImg
                maskSource: Rectangle {
                    width: userCoverImg.height
                    height: userCoverImg.height
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
    }

    Label {
        id: notifyText
        anchors {
            left:  userCover.right
            leftMargin: Theme.paddingMedium
            right: (type === 1) ? mediaImage.left : parent.right
            rightMargin: Theme.paddingMedium
            top: parent.top
            topMargin: parent.height * 0.1
        }

        wrapMode: Text.Wrap
        font.pixelSize: settings.notificationFontSize()

        color: settings.fontColor()
        linkColor: settings.linkColor()
        text: args.text
    }

    Rectangle {
        id: mediaImage
        color: settings.transparent()
        width: Theme.itemSizeSmall
        height: Theme.itemSizeSmall
        anchors {
            top: parent.top
            right: parent.right
        }

        Image {

            visible: (type === 1) ? true : false
            source: (type === 1) ? imageCache.getFromCache2(args.media[0].image) : ""

            width: parent.height * 0.8
            height: parent.height * 0.8

            fillMode: Image.PreserveAspectFit

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
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
}

