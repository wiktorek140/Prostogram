import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Settings.js" as Setting
import QtGraphicalEffects 1.0

Item {
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.1
    }

    width: parent.width
    height: parent.width * 0.24

    anchors {
        right: parent.right
        left: parent.left
    }


    Image {
       id: profilePic
       height: parent.height
       width: height
       anchors.right: parent.right
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

    Column {
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        anchors.right: profilePic.left
        anchors.rightMargin: Theme.paddingMedium
        anchors.top: parent.top
        anchors.topMargin: 10

        Label {
            text: user !== undefined && user.media_count !== undefined ? qsTr("%1 posts").arg(user.media_count) :""
            anchors.left: parent.left
            anchors.right: parent.right
            color: "black"
            visible: text!==""
            truncationMode: TruncationMode.Fade
            font.pixelSize: Setting.profileFontSize()
        }


        Label {
            text: user !== undefined && user.follower_count !== undefined ? qsTr("%1 followers").arg(Setting.skrocLiczbe(user.follower_count)) : ""
            anchors.left: parent.left
            anchors.right: parent.right
            color: "black"
            visible: text!==""
            truncationMode: TruncationMode.Fade
            font.pixelSize: Setting.profileFontSize()

        }

        Label {
            text: user !== undefined && user.following_count !== undefined ? qsTr("%1 following").arg(user.following_count) : ""
            anchors.left: parent.left
            anchors.right: parent.right
            color: "black"
            visible: text!==""
            truncationMode: TruncationMode.Fade
            font.pixelSize: Setting.profileFontSize()
        }
    }
}
