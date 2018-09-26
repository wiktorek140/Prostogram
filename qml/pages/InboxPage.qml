import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"


Page {
    id: inboxPage

    property bool isLoaded: false
    Rectangle {
        anchors.fill: parent
        color: settings.backgroundColor()
}
    BusyIndicator {
        id: loadIndicator
        anchors.centerIn: parent
        visible: true
        running: visible
    }

    Component.onCompleted: {
        if(!isLoaded) instagram.getInbox();
    }

    ListModel {
        id: inboxModel
    }

    SilicaListView {
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Inbox")
            _titleItem.color: settings.fontColor()
        }

        id: inboxView
        width: parent.width
        height: parent.height
        //clip: true
        contentHeight: (inboxModel.count) * (parent.width * 0.1852)
        model: inboxModel
        delegate: InboxItem {
            itemData: model
        }
    }

    Connections {
        target: instagram

        onInboxDataReady: {
            //print(answer)
            var out = JSON.parse(answer)
            if(out.status === "ok" && !isLoaded)
            {
                for(var i=0; i < out.inbox.threads.length; i++) {
                    inboxModel.append(out.inbox.threads[i]);
                }
                //print(out.inbox.threads.length)
                isLoaded = true;
            }
            loadIndicator.visible = false
        }
    }
}
