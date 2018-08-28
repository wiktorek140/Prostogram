import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "../components"
import "../Helper.js" as Helper
import "../MediaStreamMode.js" as MediaStreamMode

Page {
    id: explorePage
    allowedOrientations:  Orientation.All

    property var user
    property string next_id: ""
    property bool dataLoaded: false
    property int recentMediaSize: (width - 2 * Theme.paddingMedium) / 3

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    SilicaFlickable {
        id: allView
        anchors.fill: parent
        contentHeight: column.height + header.height + 10
        contentWidth: parent.width

        PageHeader {
            id: header
            title: qsTr("Explore")
            _titleItem.color: "black"
        }

        Column {
            id: column

            anchors{
                top: header.bottom
                left: parent.left
                right: parent.right
            }
            spacing: Theme.paddingSmall

            BusyIndicator {
                running: visible
                visible: !dataLoaded
                anchors.horizontalCenter: parent.horizontalCenter
            }

            GridView {
                width: parent.width
                height: allView.height
                cellWidth: width/3
                cellHeight: cellWidth
                clip: true

                anchors{
                    left: parent.left
                    right: parent.right
                }

                model: recentMediaModel

                delegate: Item {
                    //property var item: model

                    width: parent.width/3
                    height: width

                    MainItemLoader {
                        id: mainLoader
                        anchors.fill: parent
                        width: parent.width
                        preview: true
                        clip: true
                        autoVideoPlay: false
                        isSquared: true
                        property var item: model
                    }

                    MouseArea {
                        id: mousearea
                        anchors.fill: parent
                        onClicked: {
                            if(model.special === 1) {
                                recentMediaModel.remove(model.index);
                                dataLoaded = false;
                                instagram.getExploreFeed(next_id);
                            }
                            else pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:model});
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: recentMediaModel
    }

    Component.onCompleted: {
        instagram.getExploreFeed(next_id);
    }

    Connections {
        target: instagram
        onExploreFeedDataReady:{
            var data = JSON.parse(answer);

            for(var i=1; i<data.items.length; i++) {
                recentMediaModel.append(data.items[i].media);
            }
            next_id = data.next_max_id
            dataLoaded=true;

            data.items[0].media_type=1
            data.items[0].special=1
            recentMediaModel.append(data.items[0])
        }
    }
}
