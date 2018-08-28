import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: mediaDetail
    property var singleItem
    Rectangle{
        anchors.fill: parent
        color:"white"
    }
    FeedItem {
        id: singleFeedItem
        anchors {
            top:parent.top
            bottom: parent.bottom
        }
        item: singleItem

    }

    Component.onCompleted: {
        singleFeedItem.item = singleItem
        //print(JSON.stringify(singleItem))
    }
}
