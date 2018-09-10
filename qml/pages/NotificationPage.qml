import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: notificationPage

    Rectangle {
        color: "white"
        anchors.fill: parent
    }

    Component.onCompleted: {
        notifyStream.notifyCount = 0;
        instagram.getRecentActivityInbox();
    }

    onStatusChanged: {
        notifyBusy.running = false
    }

    BusyIndicator {
        id: notifyBusy
        anchors.centerIn: parent
        running: false
        size: BusyIndicatorSize.Large
    }

    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            _titleItem.color: "black"
            title: qsTr("Notifications")
        }

        VerticalScrollDecorator {
            id: scroll
        }

        model: notifyModel;
        delegate: NotifyItem {}
    }

    Connections {
        target: instagram
        onRecentActivityInboxDataReady: {
            var out = JSON.parse(answer)
            notifyModel.clear();

            out.new_stories.forEach(function(notify){
                notify.is_new = true;
                notifyModel.append(notify)
            })

            out.old_stories.forEach(function(notify){
                notifyModel.append(notify)
            })
        }
        onInfoByIdDataReady: {
            if (notificationPage.status == PageStatus.Active)
            {
                //print(answer)
                var out = JSON.parse(answer)
                pageStack.push(Qt.resolvedUrl("UserProfilPage.qml"),
                               {user: out.user})
            }
        }
    }

    ListModel {
        id: notifyModel
    }
}
