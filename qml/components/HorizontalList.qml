import QtQuick 2.5
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import harbour.prostogram.cache 1.0

Item {
    property var mediaModel
    property int storyesCount: 0
    property bool dataLoaded: false
    id: story
    width: parent.width
    height: parent.width/4

    Component.onCompleted: {
        if (!dataLoaded) {
            instagram.getReelsTrayFeed();
        }
    }

    BusyIndicator {
        running: visible
        visible: !dataLoaded
        anchors.centerIn: parent
    }

    SilicaFlickable {
        anchors.left: parent.left
        anchors.right: parent.right
        contentHeight: parent.height
        contentWidth: parent.width

        SilicaListView {
            id: listView

            height:parent.height
            width: parent.width

            implicitWidth: parent.height

            orientation: SilicaListView.Horizontal

            model: recentMediaModel

            delegate: Item {

                height: parent.height
                width: height
                property bool isViewed:false

                Image {
                    id: delegate
                    width: parent.height*0.8
                    height: parent.height*0.8

                    CacheImage {
                        id:cache
                    }

                    anchors.centerIn: parent

                    fillMode: Image.PreserveAspectCrop
                    source: cache.getFromCache(image_versions2.candidates[0].url)

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: delegate.width
                            height: delegate.height
                            Rectangle {
                                anchors.centerIn: parent
                                width: delegate.width
                                height: delegate.height
                                radius: width
                            }
                        }
                    }
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:model, isStory:true});
                        recentMediaModel.remove(model.index)
                        //Somehow stuck when try to open element durig loading/downloading
                    }
                }
            }
        }
    }

    ListModel {
        id: recentMediaModel
        onCountChanged: {
            storyesCount = recentMediaModel.count
        }
    }

    Connections {
        target: instagram
        onReelsTrayFeedDataReady: {
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
            for(var j=0;j<data.items.length;j++) {
                recentMediaModel.append(data.items[j]);
            }
        }
    }
}
