import QtQuick 2.0
import Sailfish.Silica 1.0
import "../CoverMode.js" as CoverMode
import "../MediaStreamMode.js" as MediaStreamMode

Item {
    id: streamPreviewBlock
    height: parent.height
    width: parent.width
    clip: true

    property bool recentMediaLoaded: false
    property bool errorOccurred : false
    property string tag
    property var streamData
    property string nextId : "";

    Rectangle {
        anchors.fill: parent
        color: settings.backgroundColor()
    }

    ListModel {
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

        /*PullDownMenu {
            id: topMenu;
            quickSelect: true
            background: Rectangle {
                anchors {
                    fill: parent
                    //bottomMargin: parent.spacing
                }
                color: settings.backgroundColor()
            }
            menuIndicator: Rectangle {
            height: 0
            color: "transparent"
            }
        }*/


        PushUpMenu {
            id: bottomMenu
            visible: (nextId !== "")
            quickSelect: true

            MenuItem {
                id: moreMenu
                color: settings.fontColor()
                text: qsTr("Load more")
                onClicked: {
                    instagram.getTimelineFeed(nextId)
                }
            }
        }

        section {
            property: "type"
            delegate: StoriesList { id: stories }
        }

        delegate: FeedItem {
            item: model
        }

    }

    BusyIndicator {
        anchors.centerIn: grid
        running: recentMediaLoaded == false
    }

    ErrorMessageLabel {
        visible: errorOccurred
    }

    function refresh(toUp) {
        if(toUp){
            grid.scrollToTop();
        }
        else {
            grid.scrollToTop();
            streamPreviewBlock.nextId = "";
            recentMediaLoaded = false;
            instagram.getTimelineFeed(nextId);
        }
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
            //print(answer)
            var data = JSON.parse(answer)

            if(streamPreviewBlock.nextId == "")
            {
                recentMediaModel.clear()
            }

            if(data === null || data === undefined || data.items.length === 0)
            {
                recentMediaLoaded=true;
                errorOccurred=true
                return;
            }
            errorOccurred = false

            for(var i = 0; i<data.items.length; i++) {

                if(recentMediaModel.count == 0)
                {
                    var coverdata = {}
                    if(data.items[i].media_type === 1 || data.items[i].media_type === 2)
                    {
                        coverdata.image = data.items[i].image_versions2.candidates[data.items[i].image_versions2.candidates.length-1].url
                    }
                    else if(data.items[i].media_type === 8)
                    {
                        coverdata.image = data.items[i].carousel_media[0].image_versions2.candidates[0].url
                    }
                    coverdata.username = data.items[i].user.username;
                    setCover(CoverMode.SHOW_IMAGE,coverdata)

                }

                if(data.items[i].media_type >= 1 && data.items[i].media_type !== 3 ){
                    data.items[i].type = "stories";

                    recentMediaModel.append(data.items[i]);
                }
            }

            //recentMediaModelChanged()

            streamPreviewBlock.nextId = data.next_max_id;
            recentMediaLoaded=true;
        }

        onMediaDeleted: {
            refresh(false)
        }
    }
}
