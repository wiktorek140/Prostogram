import QtQuick 2.0
import Sailfish.Silica 1.0
import "../MediaStreamMode.js" as MediaStreamMode
import "../CoverMode.js" as CoverMode

Item {
    id: streamPreviewDlock
    height: header.height + grid.height
    width: parent.width

    anchors.right: parent.right

    property string streamTitle
    property int recentMediaSize: width / streamPreviewColumnCount
    property bool recentMediaLoaded: false

    property int previewElementsCount : streamPreviewColumnCount * streamPreviewRowCount
    property bool errorOccurred : false
    property string tag

    property var streamData

    property int mode : MediaStreamMode.MY_STREAM_MODE

    Item {
        id:header

        height: Theme.itemSizeMedium
        width: parent.width
        anchors.top: parent.top


        Rectangle {
            anchors.fill: parent
            color: Theme.highlightColor
            opacity : mouseAreaHeader.pressed ? 0.3 : 0
        }

        Image {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            source:  "image://theme/icon-m-right"
        }

        Label {
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.primaryColor

            text:streamTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: icon.left
            anchors.rightMargin: Theme.paddingMedium
        }

        MouseArea {
            id: mouseAreaHeader
            anchors.fill: parent
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/MediaStreamPage.qml"),{mode : mode, streamData: streamData, streamTitle: streamTitle})
        }
    }

    Grid {
        height: {
            if(recentMediaModel.length >= streamPreviewColumnCount*streamPreviewRowCount)
            {
                recentMediaSize*streamPreviewRowCount
            }
            else
            {
                recentMediaSize*(Math.ceil(recentMediaModel.length/streamPreviewRowCount)+1)
            }
        }

        id: grid
        columns: streamPreviewColumnCount
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        visible: recentMediaLoaded

        Repeater {
            model: recentMediaModel
            delegate: Item {
                width: recentMediaSize
                height: recentMediaSize
                SmallMediaElement{
                    mediaElement: modelData
                }
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
        var elementsCount = data.items.length > previewElementsCount-recentMediaModel.length ? previewElementsCount-recentMediaModel.length : data.items.length;
        for(var i=0; i<elementsCount; i++) {
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

        if(data.items.length < streamPreviewColumnCount*streamPreviewRowCount && data.more_available)
        {
            if(streamPreviewDlock.mode === 0)
            {
                instagram.getTimeLine(data.next_max_id);
            }
            else if(streamPreviewDlock.mode === 1)
            {
                instagram.getPopularFeed(data.next_max_id);
            }
        }
    }

    function refresh()
    {
        recentMediaModel = [];
        recentMediaModelChanged()
        if(streamPreviewDlock.mode === 0)
        {
            instagram.getTimeLine();
        }
        else if(streamPreviewDlock.mode === 1)
        {
            instagram.getPopularFeed();
        }
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
            if(streamPreviewDlock.mode === 0)
            {

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

    Connections{
        target: instagram
        onPopularFeedDataReady: {
            var data = JSON.parse(answer);
            if(streamPreviewDlock.mode === 1)
            {
                loadStreamPreviewDataFinished(data);
            }
        }
    }
}
