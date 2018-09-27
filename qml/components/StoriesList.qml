import QtQuick 2.5
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import harbour.prostogram.cache 1.0

//reworked

Rectangle {
    property var mediaModel
    property int storyesCount: 0
    property bool dataLoaded: false

    id: story
    width: parent.width
    height: parent.width / 4 + settings.storyTitleSize()
    color: settings.backgroundColor()

    Component.onCompleted: {
        if (!dataLoaded) {
            instagram.getReelsTrayFeed();
        }
    }

    BusyIndicator {
        running: visible
        visible: !dataLoaded
        anchors.centerIn: parent
    }

    SilicaFlickable {
        anchors.left: parent.left
        anchors.right: parent.right

        contentHeight: parent.height
        contentWidth: parent.width

        SilicaListView {
            id: listView

            height:parent.height
            width: parent.width
            implicitWidth: parent.height
            orientation: SilicaListView.Horizontal

            model: recentMediaModel

            delegate: Item {

                height: parent.height
                width: height - settings.storyTitleSize()
                property bool isViewed: false

                Image {
                    id: delegate
                    width: parent.width * 0.75
                    height: parent.width * 0.75

                    anchors.centerIn: parent

                    fillMode: Image.PreserveAspectCrop
                    source: imageCache.getUserImageFromCache(model.user.profile_pic_url)

                    onStatusChanged: {
                        if(delegate.status === Image.Error) {
                            delegate.source = imageCache.getUserImageFromCache(model.user.profile_pic_url , true);
                        }
                    }

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: delegate.width
                            height: delegate.height
                            Rectangle {
                                anchors.centerIn: parent
                                width: delegate.width
                                height: delegate.height
                                radius: width
                            }
                        }
                    }
                }

                Label {
                    id: name
                    text: model.user.username
                    anchors {
                        top: delegate.bottom
                        //left: parent.left
                        //right: parent.right
                        horizontalCenter: delegate.horizontalCenter
                    }

                    font.pixelSize: settings.storyTitleSize()
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    color: settings.fontColor()
                    wrapMode: Text.Wrap
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/StoryShowPage.qml"),{userId: model.user.pk});
                        recentMediaModel.remove(model.index)
                    }
                }
            }
        }
    }

    ListModel {
        id: recentMediaModel
        onCountChanged: {
            storyesCount = recentMediaModel.count
        }
    }

    Connections {
        target: instagram
        onReelsTrayFeedDataReady: {
            //print(answer)
            var data = JSON.parse(answer);
            for(var i = 0; i < data.tray.length; i++) {
                recentMediaModel.append(data.tray[i]);
            }
            dataLoaded = true;
        }
    }

    Border {
        anchors.top: parent.bottom
        height: 1
        opacity: 0.3
    }
}
