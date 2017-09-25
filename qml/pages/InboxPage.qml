import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: inboxPage

    BusyIndicator {
        id: loadIndicator
        anchors.centerIn: parent
        visible: true
        running: visible
    }

    Component.onCompleted: {
        instagram.getInbox();
    }

    ListModel{
        id: inboxModel
    }

    SilicaListView{
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Inbox")
        }

        id: inboxView
        width: parent.width
        height: parent.height
        clip: true
        model: inboxModel
        delegate: InboxItem{
            item: model
        }
    }

    Connections{
        target: instagram

        onInboxDataReady:{
            var out = JSON.parse(answer)
            if(out.status === "ok")
            {
                for(var i=0; i<out.inbox.threads.length; i++) {
                    inboxModel.append(out.inbox.threads[i]);
                }
                console.log(out.inbox.threads.length)
            }
            loadIndicator.visible = false
        }
    }
}

