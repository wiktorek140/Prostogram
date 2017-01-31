import QtQuick 2.0
import Sailfish.Silica 1.0
import "../MediaStreamMode.js" as MediaStreamMode
import "../CoverMode.js" as CoverMode

Item {
    id: streamPreviewBlock
    height: parent.height
    width: parent.width

    clip: true

    anchors.right: parent.right

    property bool recentMediaLoaded: false
    property bool errorOccurred : false
    property string tag
    property var streamData
    property var nextId : "";

    ListModel{
        id: recentMediaModel;
    }

    SilicaListView {
        id: grid
        anchors.left: parent.left
        anchors.right: parent.right
        visible: recentMediaLoaded

        width: parent.width
        height: parent.height
        clip: true

        model: recentMediaModel

        PullDownMenu{
            id: topMenu;
            quickSelect: true
            MenuItem {
                id: refreshMenu
                text: qsTr("Refresh")
                visible: true
                onClicked: {
                    refresh();
                }
            }
        }

        PushUpMenu{
            id: bottomMenu
            visible: (nextId != "")
            quickSelect: true

            MenuItem {
                id: moreMenu
                text: qsTr("Load more")
                onClicked: {
                    instagram.getTimeLine(nextId)
                }
            }
        }

        delegate: Item {
            width: parent.width
            height: childrenRect.height

            FeedItem{
                item: model
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
        streamPreviewBlock.nextId = "";

        recentMediaLoaded = false;
        instagram.getTimeLine();
    }

    Component.onCompleted: {
        if(recentMediaModel.count === 0)
        {
            recentMediaLoaded = false;
            instagram.getTimeLine();
        }
    }

    Connections{
        target: instagram
        onTimeLineDataReady: {
            var data = JSON.parse(answer)
            if(recentMediaModel.count == 0)
            {
                var coverdata = {}
                coverdata.image = data.items[0].image_versions2.candidates[data.items[0].image_versions2.candidates.length-1].url
                coverdata.username = data.items[0].user.username;

                setCover(CoverMode.SHOW_IMAGE,coverdata)
            }

            if(streamPreviewBlock.nextId == "")
            {
                recentMediaModel.clear()
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
                    recentMediaModel.append(data.items[i]);
                }
            }

            //recentMediaModelChanged()

            recentMediaLoaded=true;
            streamPreviewBlock.nextId = data.next_max_id;
        }
    }
}
