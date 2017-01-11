import QtQuick 2.0
import Sailfish.Silica 1.0
import "../MediaStreamMode.js" as MediaStreamMode
import "../CoverMode.js" as CoverMode

Item {
    id: streamPreviewDlock
    height: parent.height
    width: parent.width

    anchors.right: parent.right

    property bool recentMediaLoaded: false
    property bool errorOccurred : false
    property string tag
    property var streamData
    property var nextId;

    ListView {
        id: grid
        anchors.left: parent.left
        anchors.right: parent.right
        visible: recentMediaLoaded

        width: parent.width
        height: parent.height
        clip: true

        model: recentMediaModel

        delegate: Item {
            width: parent.width
            height: childrenRect.height

            FeedItem{
                item: modelData
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: grid
        running: recentMediaLoaded == false
    }

    ErrorMessageLabel {
        visible: errorOccurred
    }

    property var recentMediaModel: [];


    function loadStreamPreviewDataFinished(data) {
        streamData = data;
        if(data ===null || data === undefined || data.items.length === 0)
        {
            recentMediaLoaded=true;
            errorOccurred=true
            return;
        }
        errorOccurred = false

        for(var i=0; i<data.items.length; i++) {
/*
TYPE 1 - IMAGE
TYPE 2 - VIDEO
TYPE 3 - FRIEND
*/
            if(data.items[i].media_type == 1 || data.items[i].media_type == 2)
            {
                recentMediaModel.push(data.items[i]);
                recentMediaModelChanged()
            }
        }
        recentMediaLoaded=true;
        nextId = data.items.length;
    }

    function refresh()
    {
        recentMediaModel = [];
        recentMediaModelChanged()
        instagram.getTimeLine();
    }

    Component.onCompleted: {
        if(recentMediaModel.length === 0)
        {
            refresh();
        }
    }

    Connections{
        target: instagram
        onTimeLineDataReady: {
            var data = JSON.parse(answer);

            if(recentMediaModel.length == 0)
            {
                var coverdata = {}
                coverdata.image = data.items[0].image_versions2.candidates[data.items[0].image_versions2.candidates.length-1].url
                coverdata.username = data.items[0].user.username;

                setCover(CoverMode.SHOW_IMAGE,coverdata)
            }
            loadStreamPreviewDataFinished(data);
        }
    }
}
