import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Helper.js" as Helper

Column {
    property var item;

    width: parent.width

    Component.onCompleted: {
        if(!item.text)
        {
            item.text = "";
        }

        labelComment.text = Helper.formatString(item.text);
    }

    Label {
        id: labelUser
        text: item.user.username + " - " + Qt.formatDateTime(
                  new Date(parseInt(item.created_at) * 1000),
                  "dd.MM.yy hh:mm")
        anchors{
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
        }
        wrapMode: Text.Wrap
        truncationMode: TruncationMode.Fade
        font.pixelSize: Theme.fontSizeTiny
        color: Theme.secondaryHighlightColor

    }
    Label {
        id: labelComment
        anchors{
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
        }
        wrapMode: Text.Wrap
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.highlightColor

        linkColor: Theme.highlightColor

        onLinkActivated: {
            linkClick(link);
        }
    }
}
