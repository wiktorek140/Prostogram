import QtQuick 2.5
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import harbour.prostogram.cache 1.0

Item {
    property var mediaModel
    id: story
    width: parent.width
    height: parent.width/4

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

            model: mediaModel

            delegate: Item{
                height: parent.height
                width: height

                property var item: model
                property bool isViewed:false

                Image {
                    id: delegate
                    width: parent.height*0.8
                    height: parent.height*0.8

                    CacheImage {
                        id:cache
                    }

                    anchors.centerIn: parent

                    fillMode: Image.PreserveAspectCrop
                    source: cache.getFromCache(item.image_versions2.candidates[0].url)

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

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:item,isStory: true});
                    }
                }
            }
        }
    }
}
