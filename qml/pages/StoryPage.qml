import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../components"
import "../Helper.js" as Helper
import "../MediaStreamMode.js" as MediaStreamMode


Page {


    allowedOrientations:  Orientation.All
    width: parent.width
    height: parent.height

    property var user
    property bool dataLoaded: false
    property int recentMediaSize: (width - 2 * Theme.paddingMedium) / 3

    onStatusChanged: {
        if (status === PageStatus.Active && !dataLoaded) {
            storiesData();
        }
    }

    HorizontalList {
        id: stories
        z: 1
        anchors{
            top: parent.top
            left: parent.left
        }
    }

    SilicaFlickable {
        id: allView
        visible:false
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: stories.bottom
        contentHeight: column.height + header.height + 10 -150
        contentWidth: parent.width

        PageHeader {
            anchors {
                top:stories.bottom
            }
            id: header
            title: "Stories"
        }

        Column {
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            id: column
            spacing: Theme.paddingSmall


            BusyIndicator {
                running: visible
                visible: !dataLoaded
                anchors.top:header.bottom
                anchors.horizontalCenter: header.horizontalCenter
            }

            GridView {
                width: column.width
                height: allView.height - 150
                cellWidth: width/3
                cellHeight: cellWidth                     
                clip: true

                anchors{
                    top: header.bottom
                    left: parent.left
                    right: parent.right
                }

                model: recentMediaModel

                delegate: Item {
                    property var item: model
                    width: parent.width/3
                    height: width

                    MainItemLoader{
                        id: mainLoader
                        anchors.fill: parent
                        width: parent.width
                        preview:true
                        clip: true

                        autoVideoPlay: false
                        isSquared: true
                    }

                    MouseArea {
                        id: mousearea
                        anchors.fill: parent
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:item,isStory: true});
                            recentMediaModel.remove(item);

                        }
                    }
                }

            }
        }
    }

    ListModel {
        id: recentMediaModel
    }

    function storiesData() {
        instagram.getReelsTrayFeed();
    }

    Connections {
        target: instagram
        onReelsTrayFeedDataReady:{
            var data = JSON.parse(answer);
            var obj;
            for(var i=0; i<data.tray.length; i++) {
                obj= data.tray[i];
                //print(i)
                if(obj.items !== undefined)
                    for(var j=0;j<obj.items.length;j++){
                    recentMediaModel.append(obj.items[j]);
                }
                else
                {
                    instagram.getUserReelsMediaFeed(obj.user.pk);
                }
            }
            dataLoaded=true;
        }
        onUserReelsMediaFeedDataReady: {
            while(!dataLoaded){}
            var data = JSON.parse(answer);
            for(var j=0;j<data.items.length;j++){
                recentMediaModel.append(data.items[j]);
            }
        }
    }
}
