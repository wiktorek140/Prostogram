import QtQuick 2.0
import Sailfish.Silica 1.0
import "../MediaStreamMode.js" as MediaStreamMode


Page {
    id: threadView

    height: parent.height
    width: parent.width

    clip: true

    PageHeader {
        id: header
        title: user
    }

    property bool threadLoaded: false
    property string cursorId : "";
    property string newestCursor: "";
    property string oldestCursor: "";
    property string user:"";
    property string threadId;

    ListModel{
        id: threadModel;
    }

    SilicaListView {
        id: grid
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: threadLoaded

        width: parent.width
        height: parent.height
        clip: true

        model: threadModel

        PullDownMenu{
            id: topMenu;
            quickSelect: true
            visible: (newestCursor !== "")
            MenuItem {
                id: refreshMenu
                text: qsTr("Refresh")
                visible: true
                onClicked: {
                    instagram.getDirectThread(threadId,newestCursor);
                }
            }
        }

        PushUpMenu {
            id: bottomMenu
            visible: (oldestCursor !== "")
            quickSelect: true

            MenuItem {
                id: moreMenu
                text: qsTr("Load older")
                onClicked: {
                    instagram.getDirectThread(threadId,oldestCursor);
                }
            }
        }

        delegate: Item {
            width: parent.width
            height: 100

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"
                border.color: "black"

                Label {
                    text: model.text
                }

            }
        }
    }

    BusyIndicator {
        anchors.centerIn: grid
        running: threadLoaded == false
    }

    Component.onCompleted: {
        if(threadModel.count === 0)
        {
            threadLoaded = false;
            instagram.getDirectThread(threadId);

        }
    }

    Connections{
        target: instagram
        onDirectThreadDataReady: {
            //print(answer);
            var data = JSON.parse(answer);

            for(var j=0;j<data.thread.items.length;j++) {
                threadModel.append(data.thread.items[j]);
            }
            user = data.thread.users[0].username
            if(data.thread.has_newer){newestCursor = data.thread.newest_cursor;}
            if(data.thread.has_older){oldestCursor = data.thread.oldest_cursor;}
            threadLoaded = true;
        }
    }
}
