import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

Rectangle {
    property var item

    width: parent.width
    height: conversationCover.height

    color: "transparent"
    clip: true


    Image {
        id: conversationCover
        source: item.users.get(0).profile_pic_url
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: conversationCover.width
                height: conversationCover.height
                Rectangle {
                    anchors.centerIn: parent
                    width: conversationCover.width
                    height: conversationCover.height
                    radius: width
                }
            }
        }
    }

    Text {
        id: conversationUser
        text: item.users.get(0).full_name ? item.users.get(0).full_name : item.users.get(0).username

        width: parent.width-conversationCover.width-Theme.paddingSmall*2
        wrapMode: Text.WordWrap

        maximumLineCount: 1

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
        text: (item.items.get(0).item_type === "text") ? item.items.get(0).text : (item.items.get(0).user_id === instagram.getUsernameId()) ? qsTr("You send message") : qsTr("You get message")

        width: parent.width-conversationCover.width-Theme.paddingSmall*2
        height: parent.height-conversationUser.height-Theme.paddingSmall*2

        wrapMode: Text.WordWrap
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
            pageStack.push(Qt.resolvedUrl("ThreadView.qml"),{threadId:item.thread_id, user:item.users.get(0).username});
        }
    }
}
