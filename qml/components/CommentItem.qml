import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

import "../Helper.js" as Helper

Rectangle {
    property var item;

    width: parent.width
    height: ((labelTime.height + labelComment.height + 10) > width * 0.15) ? labelTime.height + labelComment.height + 10 :  width * 0.15

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: Theme.paddingSmall
        rightMargin: Theme.paddingSmall
    }

    Border {
        id: topBorder
    }

    Border {
        id: bottomBorder
        anchors.top: parent.bottom
    }

    Component.onCompleted: {
        if(!item.text)
        {
            item.text = "";
        }
        labelComment.text = "<b>"+item.user.username+"</b> "+ Helper.formatString(item.text);

        labelTime.text = Qt.formatDateTime(new Date(parseInt(item.created_at) * 1000),
                                           "dd.MM.yy hh:mm");

        userIcon.source = item.user.profile_pic_url
    }

    Image {
        id: userIcon
        width: parent.width * 0.15
        height: width

        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
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
        anchors{
            top: topBorder.bottom
            left: userIcon.right
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
        }
        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeExtraSmall
        color: "black"
        linkColor: "navy"
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
        font.pixelSize: Theme.fontSizeTiny + 1
        color: "black"
    }
}
