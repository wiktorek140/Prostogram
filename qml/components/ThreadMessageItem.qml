import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
import "../js/Settings.js" as Setting

BackgroundItem {

    id: threadMessageItem

    property var item
    property string pic_url;
    property bool isSelf: false;
    property bool isText: model.item_type === "text" ? true : false;

    height: isText ? message.height + (2*Theme.paddingLarge) : parent.width * 0.792;
    width: parent.width

    Image {
        id: profilePicture

        anchors.left: isSelf ? undefined : parent.left
        anchors.right: isSelf ? parent.right : undefined
        anchors.top: parent.top

        height: parent.width * 0.1
        width: parent.width * 0.1
        source: pic_url
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: profilePicture.width
                height: profilePicture.height
                Rectangle {
                    anchors.centerIn: parent
                    width: profilePicture.width
                    height: profilePicture.height
                    radius: width
                }
            }
        }
    }

    Label {
        id: message
        visible: isText
        text: isText? model.text : ""
        anchors {
            top: parent.top
            right: isSelf ? profilePicture.left : parent.right
            left: isSelf ? parent.left : profilePicture.right
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge
            topMargin: Theme.paddingMedium
        }

        //width: parent.width - profilePicture.width - Theme.paddingMedium * 4
        wrapMode: Text.Wrap
        textFormat: Text.StyledText
        color: Setting.STYLE_COLOR_FONT

        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.paddingSmall

            border.width: isSelf ? 0 : 2
            radius: 30
            opacity: 0.2
            color: isSelf ? Setting.STYLE_COLOR_INBOX_GRAY : "transparent"
        }
    }

    Image {
        visible: !isText
        anchors.left: profilePicture.right
        anchors.leftMargin: Theme.paddingMedium

        width: parent.width - profilePicture.width - Theme.paddingMedium
        height: width

        source: isText? "" : model.media_share.image_versions2.candidates[0].url
    }

}
