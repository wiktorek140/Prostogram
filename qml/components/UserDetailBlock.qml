import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
import "../Helper.js" as Helper

Item {
    Rectangle {
        anchors.fill: parent
        color: settings.fontColor()
        opacity: 0.1
    }

    width: parent.width
    height: parent.width * 0.24

    anchors {
        right: parent.right
        left: parent.left
    }

    Rectangle {
        id: profileRect
        height: parent.height
        width: height
        anchors.right: parent.right
color: settings.transparent()

        Image {
            id: profilePic
            height: parent.height * 0.8
            width: height
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            source: user.profile_pic_url
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: profilePic.width
                    height: profilePic.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: profilePic.width
                        height: profilePic.height
                        radius: width
                    }
                }
            }
        }
    }

    Column {
        anchors {
            left: parent.left
            leftMargin: Theme.paddingLarge
            right: profileRect.left
            rightMargin: Theme.paddingMedium
            top: parent.top
            topMargin: 10
        }

        Label {
            text: user !== undefined && user.media_count !== undefined ? qsTr("%1 posts").arg(user.media_count) :""
            anchors.left: parent.left
            anchors.right: parent.right
            color: settings.fontColor()
            visible: text!==""
            truncationMode: TruncationMode.Fade
            font.pixelSize: settings.profileFontSize()
        }

        Label {
            text: user !== undefined && user.follower_count !== undefined ? qsTr("%1 followers").arg(Helper.skrocLiczbe(user.follower_count)) : ""
            anchors.left: parent.left
            anchors.right: parent.right
            color: settings.fontColor()
            visible: text!==""
            truncationMode: TruncationMode.Fade
            font.pixelSize: settings.profileFontSize()
        }

        Label {
            text: user !== undefined && user.following_count !== undefined ? qsTr("%1 following").arg(Helper.skrocLiczbe(user.following_count)) : ""
            anchors.left: parent.left
            anchors.right: parent.right
            color: settings.fontColor()
            visible: text!==""
            truncationMode: TruncationMode.Fade
            font.pixelSize: settings.profileFontSize()
        }
    }
}
