import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: notificationPage

    Component.onCompleted: {
        instagram.getRecentActivity();
    }

    onStatusChanged: {
        notifyBisy.running = false
    }

    BusyIndicator {
        id: notifyBisy
        anchors.centerIn: parent
        running: false
        size: BusyIndicatorSize.Large
    }

    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: "Notifications"
        }

        VerticalScrollDecorator {
            id: scroll
        }

        model: notifyModel;
        delegate: NotifyItem{}
    }

    Connections{
        target: instagram
        onRecentActivityDataReady:{
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
    }

    Connections{
        target: instagram
        onMediaInfoReady:{
            var mediaElement = JSON.parse(answer);
            pageStack.push(Qt.resolvedUrl("MediaDetailPage.qml"),{item:mediaElement.items[0]});
        }
    }

    ListModel{
        id: notifyModel
    }
}
