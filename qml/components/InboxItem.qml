import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

Item {
    property var itemData

    width: parent.width
    height: conversationCover.height + (2*Theme.paddingSmall)

    anchors {
        topMargin: Theme.paddingSmall
        bottomMargin: Theme.paddingSmall
    }

    Image {
        id: conversationCover
        source: itemData.users.get(0).profile_pic_url

        height: parent.width * 0.1852
        width: height
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

    Column {
        width: parent.width - conversationCover.width - (Theme.paddingLarge*2)
        anchors {
            left: conversationCover.right
            right: parent.right
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge
            verticalCenter: conversationCover.verticalCenter
        }

        Text {
            id: conversationUser
            text: itemData.users.get(0).username

            width: parent.width
            wrapMode: Text.WordWrap
            maximumLineCount: 1

            anchors {
                //top: conversationCover.top
                left: parent.left
                leftMargin: Theme.paddingLarge
            }
            font.pixelSize: settings.inboxFontSize()
            font.bold: true
            color: settings.fontColor()
        }

        Text {
            id: conversationLastItem
            text: (itemData.items.get(0).item_type === "text") ? itemData.items.get(0).text : qsTr("Raven Message.")

            width: parent.width
            //height: parent.height - conversationUser.height - (Theme.paddingSmall*2)

            wrapMode: Text.WordWrap
            anchors {
                //top: conversationUser.bottom
                left: parent.left
                //topMargin: Theme.paddingSmall
                leftMargin: Theme.paddingLarge

            }
            color: settings.inboxFontColor()
            maximumLineCount: 1
            font.pixelSize: settings.inboxFontSize()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Load thread "+itemData.thread_id)
            pageStack.push(Qt.resolvedUrl("ThreadView.qml"),{threadId: itemData.thread_id, user: itemData.users.get(0).username});
        }
    }
}
