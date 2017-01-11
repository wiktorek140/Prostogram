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

    onStatusChanged: {
        if (status === PageStatus.Active) {
            refreshCallback = startPageRefreshCB
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
    }

    SilicaFlickable {
        anchors{
            top: header.bottom
            left: parent.left
        }

        height: parent.height-header.height-bottom.height
        width: parent.width

        //contentHeight: column.height
        contentWidth: parent.width


        StreamPreviewBlock {
            id: myFeedBlock

            anchors.fill: parent
        }
    }

    FeedBottom{
        id: bottom
        anchors{
            bottom: parent.bottom
        }
    }


    PullDownMenu {
        MenuItem {
            text: qsTr("Settings")
            onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
        }

        MenuItem {
            text: qsTr("Search")
            onClicked: pageStack.push(Qt.resolvedUrl("TagSearchPage.qml"))
        }

        MenuItem {
            text: qsTr("Send photo from phone")
        }

        MenuItem {
            text: qsTr("Refresh")
            onClicked: updateAllFeeds()
        }
    }

    ListModel {
        id: recentMediaModel
    }

    function startPageRefreshCB() {

        if (updateRunning) {
            return
        }
        console.log("update...")
        updateRunning = true
        myFeedBlock.refreshContent(refreshDone)
    }

    Connections{
        target: instagram
        onProfileConnected:{
            startPage.user_id = instagram.getUsernameId();
            instagram.getUsernameInfo(startPage.user_id);
            instagram.getRecentActivity();
        }
    }

    Connections{
        target: instagram
        onUsernameDataReady: {
            var obj = JSON.parse(answer)
            if(obj.user.pk === startPage.user_id)
            {
                user = obj.user
                app.user = obj.user
            }
        }
    }

    Connections{
        target: instagram
        onProfileConnectedFail:{
            app.cover = Qt.resolvedUrl("AuthPage.qml")
        }
    }

    Connections{
        target: app
        onCoverRefreshButtonPress:{
            updateAllFeeds()
        }
    }
}
