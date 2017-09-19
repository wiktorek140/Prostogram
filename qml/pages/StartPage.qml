import QtQuick 2.2
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import QtQuick.LocalStorage 2.0

import "../components"
import "../MediaStreamMode.js" as MediaStreamMode

Page {
    allowedOrientations:  Orientation.All
    id: startPage
    property var user
    property int user_id
    property bool relationStatusLoaded: false
    property bool recentMediaLoaded: false
    property bool updateRunning: false
    property string favoriteTag: ""

    property bool storyDataLoaded: false

    onStatusChanged: {
        if (status === PageStatus.Active) {
            refreshCallback = startPageRefreshCB
            instagram.storiesFeed();
        }
    }

    function updateAllFeeds() {
        if (updateRunning) {
            return
        }

        myFeedBlock.refresh();
        if(popularFeedBlock.visible)
        {
            popularFeedBlock.refresh();
        }

        if(favoriteTagFeedBlock.refresh())
        {
            favoriteTagFeedBlock.refresh();
        }
    }


    function refreshFavoriteTagFeedBlock() {

        if(FavManager.favTag===null) FavManager.favTag = ""

        console.log("current fav " + favoriteTag + " - new " + FavManager.favTag)
        if(favoriteTag!==FavManager.favTag) {
            favoriteTag = FavManager.favTag
        }

        favoriteTagFeedBlock.refreshContent(refreshDone)
    }

    FeedHeader{
        id: header
        z: 2
    }

    SilicaFlickable {
        z: 1
        anchors{
            top: header.bottom
            left: parent.left
        }

        height: parent.height-header.height-bottom.height
        width: parent.width

        contentWidth: parent.width

        HorizontalList {
            id: stories
            z: 1
            mediaModel: storiesModel
            anchors.top: parent.top
            visible: storiesModel.count > 0
            BusyIndicator {
                running: visible
                visible: !storyDataLoaded
                anchors.centerIn: parent
            }
        }

        StreamPreviewBlock {
            id: myFeedBlock
            anchors{
                top: (storiesModel.count > 0) ? stories.bottom : parent.top
            }
        }
    }

    FeedBottom{
        id: bottom
        z: 2
        anchors{
            bottom: parent.bottom
        }
    }

    ListModel {
        id: recentMediaModel
    }

    ListModel {
        id: storiesModel
    }

    function startPageRefreshCB() {

        if (updateRunning) {
            return
        }
        updateRunning = true
        myFeedBlock.refreshContent(refreshDone)
    }

    Connections {
        target: instagram
        onStoriesDataReady:{
            var data = JSON.parse(answer);
            var obj;
            for(var i=0; i<data.tray.length; i++) {
                obj= data.tray[i];
                if(obj.items != undefined)
                    for(var j=0;j<obj.items.length;j++){
                        storiesModel.append(obj.items[j]);
                    }
            }
            storyDataLoaded=true;
        }
    }
}
