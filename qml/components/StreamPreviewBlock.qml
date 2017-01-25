import QtQuick 2.0
import Sailfish.Silica 1.0
import "../MediaStreamMode.js" as MediaStreamMode
import "../CoverMode.js" as CoverMode

Item {
    id: streamPreviewBlock
    height: parent.height
    width: parent.width

    anchors.right: parent.right

    property bool recentMediaLoaded: false
    property bool errorOccurred : false
    property string tag
    property var streamData
    property var nextId : false;

    property var recentMediaModel: [];

    Label{
        id: refreshLabel
        text: qsTr("Refresh")
        anchors{
            top: parent.top
        }
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeMedium
        visible: false;
        opacity: 0
    }

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

        onContentYChanged: {
            if(grid.contentY < -10)
            {
                refreshLabel.visible = true
                refreshLabel.opacity = Math.abs(grid.contentY-10)/100
            }

            if(grid.contentY >= -10)
            {
                refreshLabel.visible = false
            }
            if(grid.contentY < -110)
            {
                refreshLabel.visible = false
                refresh();
            }

            if((grid.contentY+grid.height)>Math.max(grid.contentHeight, grid.height))
            {
                if(nextId && recentMediaLoaded)
                {
                    recentMediaLoaded = false;
                    instagram.getTimeLine(nextId)
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

    function refresh()
    {
        streamPreviewBlock.nextId = false;

        recentMediaLoaded = false;
        instagram.getTimeLine();
    }

    Component.onCompleted: {
        if(recentMediaModel.length === 0)
        {
            recentMediaLoaded = false;
            instagram.getTimeLine();
        }
    }

    Connections{
        target: instagram
        onTimeLineDataReady: {
            console.log(streamPreviewBlock.nextId)

            var data = JSON.parse(answer);

            if(recentMediaModel.length == 0)
            {
                var coverdata = {}
                coverdata.image = data.items[0].image_versions2.candidates[data.items[0].image_versions2.candidates.length-1].url
                coverdata.username = data.items[0].user.username;

                setCover(CoverMode.SHOW_IMAGE,coverdata)
            }

            if(!streamPreviewBlock.nextId)
            {
                recentMediaModel = [];
            }

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
                }
            }
            recentMediaModelChanged()

            recentMediaLoaded=true;
            streamPreviewBlock.nextId = data.next_max_id;
        }
    }
}
