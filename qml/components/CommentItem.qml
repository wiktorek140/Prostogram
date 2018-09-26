import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

import "../Helper.js" as Helper

Item {
    id: commentSingleItem
    property var item;

    width: parent.width;
    height: Screen.width * 0.1852;
    //height: ((labelTime.height + labelComment.height + 10) > width * 0.15) ? labelTime.height + labelComment.height + 10 :  width * 0.15

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: Theme.paddingSmall
        rightMargin: Theme.paddingSmall
    }

    Border {
        id: topBorder
    }

    Component.onCompleted: {
        if(!item.text) {
            item.text = "";
        }
        labelComment.text = "<b>"+item.user.username+"</b> "+ Helper.formatString(item.text);

        labelTime.text = Qt.formatDateTime(new Date(parseInt(item.created_at) * 1000),
                                           "dd.MM.yy hh:mm");

        userIcon.source = item.user.profile_pic_url
        commentSingleItem.height = ((labelTime.height + labelComment.height + 10) > width * 0.15) ? labelTime.height + labelComment.height + 10 :  Screen.width * 0.1852;

    }

    Image {
        id: userIcon
        width: Screen.width * 0.1852 * 0.8
        height: width

        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            top: parent.top
            topMargin: Theme.paddingMedium
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            anchors.fill: userIcon
            maskSource: Rectangle {
                //id: mask
                //anchors.centerIn: userCover
                width: userIcon.height
                height: userIcon.height
                radius: width
                //visible:false
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                instagram.getInfoById(item.user.pk);
            }
        }
    }

    Label {
        id: labelComment
        anchors {
            top: topBorder.bottom
            left: userIcon.right
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
        }
        wrapMode: Text.Wrap
        font.pixelSize: settings.extra_small
        color: settings.fontColor()
        linkColor: settings.linkColor()
        textFormat: Text.StyledText

        onLinkActivated: {
            linkClick(link);
        }
    }

    Label {
        id: labelTime
        anchors {
            top: labelComment.bottom
            left: userIcon.right
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
        }
        wrapMode: Text.Wrap
        truncationMode: TruncationMode.Fade
        font.pixelSize: settings.tiny + 1
        color: settings.fontColor()
    }

    Border {
        id: bottomBorder
        anchors.top: parent.bottom
    }
}


