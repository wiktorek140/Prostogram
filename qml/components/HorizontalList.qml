import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.prostogram.cache 1.0

Item {

    id: story
    width: parent.width
    height: parent.width/3
    property bool dataLoaded:false


    Component.onCompleted: {
        if (!dataLoaded) {
            storiesData();
        }
    }
    SilicaFlickable {
        anchors.left: parent.left
        anchors.right: parent.right
        contentHeight: parent.height
        contentWidth: parent.width

        HorizontalScrollDecorator {
            flickable: parent
            anchors.bottom: parent.bottom
        }

        SilicaListView {
            id: listView

            anchors.left: parent.left
            anchors.right: parent.right

            height:parent.height
            implicitWidth: parent.height
            width: parent.width
            orientation: SilicaListView.Horizontal

            model: recentMediaModel

            delegate: Image {

                CacheImage {
                    id:cache
                }

                property var item: model
                id: storyDelegate
                width: parent.height
                height: parent.height
                fillMode: Image.PreserveAspectFit
                source: cache.getFromCache(item.image_versions2.candidates[0].url)

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:item, isStory:true});
                        itimer.start()
                    }

                }
                Timer {
                    id: itimer
                    interval: 1000;
                    running: false
                    repeat: false
                    triggeredOnStart: false
                    onTriggered: recentMediaModel.remove(model.index)
                }
            }
        }
    }

    ListModel {
        id: recentMediaModel
    }

    function storiesData() {
        instagram.getReelsTrayFeed();
    }

    Connections {
        target: instagram
        onReelsTrayFeedDataReady:{
            var data = JSON.parse(answer);
            var obj;
            for(var i=0; i<data.tray.length; i++) {
                obj= data.tray[i];
                if(obj.items !== undefined)
                    for(var j=0;j<obj.items.length;j++){
                    recentMediaModel.append(obj.items[j]);
                }
                else
                {
                    instagram.getUserReelsMediaFeed(obj.user.pk);
                }
            }
            dataLoaded=true;
        }
        onUserReelsMediaFeedDataReady: {
            while(!dataLoaded){}
            var data = JSON.parse(answer);
            for(var j=0;j<data.items.length;j++){
                recentMediaModel.append(data.items[j]);
            }
        }
    }
}
