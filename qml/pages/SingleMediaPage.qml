import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../MediaTypes.js" as MediaType

Page {
    id: mediaDetail
    property var singleItem
    Rectangle {
        anchors.fill: parent
        color:"white"
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: singleFeedItem.height

        FeedItem {
            id: singleFeedItem
            anchors {
                top:parent.top
                bottom: parent.bottom
            }
            item: singleItem
            type: singleItem.media_type === MediaType.VIDEO_PREVIEW_TYPE ? MediaType.VIDEO_TYPE : 0
        }
    }
}
