import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.prostogram.cache 1.0

Item {
    property var mediaModel

    id: story
    width: parent.width
    height: parent.width/3

    SilicaFlickable {
        anchors.left: parent.left
        anchors.right: parent.right
        contentHeight: parent.height
        contentWidth: parent.width

        HorizontalScrollDecorator {
            flickable: parent
            anchors.bottom: parent.bottom
        }

        SilicaListView {
            id: listView

            anchors.left: parent.left
            anchors.right: parent.right

            height:parent.height
            implicitWidth: parent.height

            width: parent.width
            orientation: SilicaListView.Horizontal

            model: mediaModel

                /*ListModel {
                ListElement { fruit: "camera.svg" }
                ListElement { fruit: "crop.svg" }
                ListElement { fruit: "heart-o.svg" }
                ListElement { fruit: "volume-off.svg" }
                ListElement { fruit: "carusel.svg" }
            }*/

            delegate: Image {

                CacheImage {
                    id:cache
                }
                property var item: model
                property bool isViewed:false
                id: delegate
                width: parent.height
                height: parent.height
                visible: !isViewed
                fillMode: Image.PreserveAspectFit
                source: cache.getFromCache(item.image_versions2.candidates[0].url)
                onIsViewedChanged: {
                    visible=false

                }
                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: {
                        isViewed=true
                        pageStack.push(Qt.resolvedUrl("../pages/MediaDetailPage.qml"),{item:item,isStory: true});
                    }
                }
            }
        }
    }
}
