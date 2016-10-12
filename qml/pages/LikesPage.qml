import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    property var mediaId

    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Likes")
        }

        VerticalScrollDecorator {
            id: scroll
        }

        model: likesModel
        delegate: LikesItem{
            item: model
        }
    }

    ListModel{
        id: likesModel
    }

    BusyIndicator{
        id: busyIndicator
        anchors.centerIn: parent
        running: true
        size: BusyIndicatorSize.Large
    }

    Component.onCompleted: {
        console.log(mediaId);
        instagram.getMediaLikers(mediaId);
    }

    Connections{
        target: instagram
        onMediaLikersDataReady: {
            busyIndicator.running = false;
            var out = JSON.parse(answer)
            if(out.status === "ok")
            {
                for(var i=0; i<out.users.length; i++) {
                    likesModel.append(out.users[i]);
                }
            }
        }
    }
}
