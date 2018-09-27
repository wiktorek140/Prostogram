import QtQuick 2.2
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import QtQuick.LocalStorage 2.0
import harbour.prostogram.cache 1.0

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


    onStatusChanged: {
        if (status === PageStatus.Active) {
            refreshCallback = startPageRefreshCB
        }
    }

    FeedHeader {
        id: header
        z: 2
    }

    StreamPreviewBlock {
        id: myFeedBlock
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: bottomFeed.top
        }
        //height: parent.height - header.height - bottomFeed.height
        //width: parent.width
    }

    FeedBottom {
        id: bottomFeed
        z: 2
        anchors{
            bottom: parent.bottom
        }
        onHomeClick: {
            myFeedBlock.refresh(isDouble)
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
        //print("current fav " + favoriteTag + " - new " + FavManager.favTag)
        if(favoriteTag!==FavManager.favTag) {
            favoriteTag = FavManager.favTag
        }
        favoriteTagFeedBlock.refreshContent(refreshDone)
    }

    function startPageRefreshCB() {

        if (updateRunning) {
            return
        }
        updateRunning = true
        myFeedBlock.refreshContent(refreshDone)
    }   
}
