import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle{
    property var item

    width: parent.width
    height: conversationCover.height

    color: "transparent"
    clip: true

    Image{
        id: conversationCover
        source: item.users.get(0).profile_pic_url
    }

    Text{
        id: conversationUser
        text: item.users.get(0).full_name ? item.users.get(0).full_name : item.users.get(0).username

        anchors{
            top: conversationCover.top
            left: conversationCover.right
            leftMargin: Theme.paddingSmall
        }
        font.pixelSize:Theme.fontSizeMedium
        font.bold: true
        color: Theme.highlightColor
    }

    Text{
        id: conversationLastItem
        text: (item.items.get(0).item_type == "text") ? item.items.get(0).text : (item.items.get(0).user_id == instagram.getUsernameId()) ? qsTr("You send message") : qsTr("You get message")

        anchors{
            top: conversationUser.bottom
            topMargin: Theme.paddingSmall
            left: conversationUser.left
        }
        color: Theme.secondaryColor
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            console.log("Load thread "+item.thread_id)
        }
    }
}
