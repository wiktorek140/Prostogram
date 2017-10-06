import QtQuick 2.0

ListView {
    id: caruselListView
    width: parent.width
    height: parent.height

    model: item.carousel_media

    orientation: Qt.Horizontal
    focus: true

    snapMode: ListView.SnapOneItem

    move: Transition {
        NumberAnimation { properties: "x"; duration: 1000 }
    }

    delegate: Image {
        source: image_versions2.candidates[0].url
    }

    Timer{
        id:timer
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if(caruselListView.currentIndex == caruselListView.count-1)
            {
               caruselListView.currentIndex = 0
            }
            else
            {
                caruselListView.currentIndex++
            }
        }
    }

    Image{
        source: "../images/carusel.svg"
        width: parent.width/20
        height: parent.width/20

        sourceSize.height: height
        sourceSize.width: height

        anchors{
            left: parent.left
            leftMargin: parent.width/25
            bottom: parent.bottom
            bottomMargin: parent.width/25
        }
    }
}
