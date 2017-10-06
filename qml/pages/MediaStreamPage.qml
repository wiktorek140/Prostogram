import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

import "../Helper.js" as Helper
import "../components"
import "../MediaStreamMode.js" as MediaStreamMode
import "../Storage.js" as Storage
import "../CoverMode.js" as CoverMode
import "../FavManager.js" as FavManager

Page {
    id: page

    allowedOrientations:  Orientation.All
    property bool dataLoaded: false

    property int mode

    property string streamTitle
    property bool errorOccurred: false
    property var streamData: null
    property bool refreshStreamData : true
    property string tag: ""

    property bool more_available
    property string next_max_id

    SilicaListView {
        id: listView
        model: mediaStreamModel
        anchors.fill: parent
        header: PageHeader {
            title: streamTitle
        }

        delegate: FeedItem {
            visible: dataLoaded
            item: model
        }

        VerticalScrollDecorator {
            id: scroll
        }

        PullDownMenu {

            MenuItem {
                visible: mode === MediaStreamMode.TAG_MODE && tag !== ""
                text: qsTr("Pin this tag feed")
                onClicked: {
                    FavManager.addFavTag(tag)
                    saveFavTags()
                    console.log("current fav: " + FavManager.favTag)
                    if(FavManager.favTag==="")  {
                        FavManager.favTag = tag
                        console.log("favnow " + FavManager.favTag)
                        Storage.set("favtag", tag)
                    }
                }
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    dataLoaded = false
                    mediaStreamModel.clear();
                    getMedia();
                }
            }
        }

        PushUpMenu {
            visible: more_available
            MenuItem {
                text: qsTr("Load more")
                onClicked: {
                    getMedia(next_max_id)
                }
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: dataLoaded == false
        size: BusyIndicatorSize.Large
    }

    ErrorMessageLabel {
        visible: errorOccurred
    }

    ErrorMessageLabel {
        visible: dataLoaded && !errorOccurred && mediaStreamModel.count === 0
        text: qsTr("There is no picture in this feed.")
    }

    ListModel {
        id: mediaStreamModel
    }

    Component.onCompleted: {
        getMedia();
    }

    function getMedia(next_id)
    {
        if(mode === MediaStreamMode.MY_STREAM_MODE)
        {
            instagram.getTimelineFeed(next_id);
        }
        else if(mode === MediaStreamMode.POPULAR_MODE)
        {
            instagram.getPopularFeed(next_id)
        }
        else if(mode === MediaStreamMode.TAG_MODE)
        {
            instagram.getTagFeed(tag)
        }
        else if(mode === MediaStreamMode.USER_MODE)
        {
            instagram.getUserFeed(tag,next_id);
        }
    }

    function mediaStreamPageRefreshCB() {
        listView.positionViewAtBeginning()
        getMediaData(true)
    }

    function getMediaData(cached) {
        dataLoaded = false
        mediaStreamModel.clear()
        refreshStreamData = true
        getFeed(mode, tag, cached, mediaDataFinished)
    }

    function mediaDataFinished(data) {
        streamData = data;
        if(data ===null || data === undefined || data.items.length === 0)
        {
            dataLoaded=true;
            errorOccurred=true
            return;
        }
        errorOccurred = false

        for(var i=0; i<data.items.length; i++) {
            mediaStreamModel.append(data.items[i]);
        }

        dataLoaded = true

        page.more_available = data.more_available
        if(page.more_available)
        {
            page.next_max_id = data.next_max_id
        }
        else
        {
            page.next_max_id = "";
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            refreshCallback = mediaStreamPageRefreshCB
            setCoverRefresh(CoverMode.SHOW_FEED, streamData, mode,tag)
        }
    }

    Connections{
        target: instagram
        onTimelineFeedDataReady: {
            var data = JSON.parse(answer);
            if(page.mode === MediaStreamMode.MY_STREAM_MODE)
            {
                mediaDataFinished(data);
            }
        }
        onPopularFeedDataReady: {
            var data = JSON.parse(answer);
            if(page.mode === MediaStreamMode.POPULAR_MODE)
            {
                mediaDataFinished(data);
            }
        }
        onTagFeedDataReady: {
            var data = JSON.parse(answer);
            if(mode === MediaStreamMode.TAG_MODE)
            {
                mediaDataFinished(data);
            }
        }
        onUserFeedDataReady: {
            var data = JSON.parse(answer);
            if(page.mode === MediaStreamMode.USER_MODE)
            {
                mediaDataFinished(data);
            }
        }
    }
}
