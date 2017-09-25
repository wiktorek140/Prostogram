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

    property int pWidth: parent.width>0?parent.width:500;
    property bool recentMediaLoaded: false
    property bool errorOccurred : false
    property string tag
    property var streamData
    property string nextId : "";

    ListModel{
        id: recentMediaModel;
    }



    SilicaListView {
        id: grid
        anchors.left: parent.left
        anchors.right: parent.right
        visible: recentMediaLoaded

        width: pWidth

        height: parent.height
        clip: true

        model: recentMediaModel

        PullDownMenu {
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


        PushUpMenu {
            id: bottomMenu
            visible: (nextId !== "")
            quickSelect: true

            MenuItem {
                id: moreMenu
                text: qsTr("Load more")
                onClicked: {
                    instagram.getTimelineFeed(nextId)
                }
            }
        }

        delegate: Item {

            width: pWidth
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
        instagram.getTimelineFeed(nextId);
    }

    Component.onCompleted: {
        if(recentMediaModel.count === 0)
        {
            recentMediaLoaded = false;
            instagram.getTimelineFeed(nextId);
        }
    }

    Connections{
        target: instagram
        onTimelineFeedDataReady: {
            var data = JSON.parse(answer)

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
                TYPE 8 - CARUSEL
                */

                if(recentMediaModel.count == 0)
                {
                    var coverdata = {}
                    if(data.items[i].media_type == 1 || data.items[i].media_type == 2)
                    {
                        coverdata.image = data.items[i].image_versions2.candidates[data.items[i].image_versions2.candidates.length-1].url
                    }
                    else if(data.items[i].media_type == 8)
                    {
                        coverdata.image = data.items[i].carousel_media[0].image_versions2.candidates[0].url
                    }
                    coverdata.username = data.items[i].user.username;
                    setCover(CoverMode.SHOW_IMAGE,coverdata)

                }

                if(data.items[i].media_type >= 1 ){
                    recentMediaModel.append(data.items[i]);
                }
            }

            //recentMediaModelChanged()

            recentMediaLoaded=true;
            streamPreviewBlock.nextId = data.next_max_id;
        }
        onMediaDeleted:{
            refresh()
        }
    }
}
