import QtQuick 2.0

Rectangle{
    id: mainItemLoader
    anchors.fill: parent
    width: parent.width

    property bool autoVideoPlay: true
    property bool isSquared: false

    clip: true
    color: "transparent"

    Loader{
        id: mainLoader
        anchors.fill: parent
        width: parent.width

        clip: true

        property var item
        property bool autoVideoPlay: true
        property bool isSquared: false
    }

    Component.onCompleted: {
        item.autoVideoPlay = mainItemLoader.autoVideoPlay
        item.isSquared = mainItemLoader.isSquared

        mainLoader.item = item

        if(item.media_type == 1 || item.media_type == 2)
        {
            if(!mainItemLoader.isSquared)
            {
                image.height = parent.width/item.image_versions2.candidates[0].width*item.image_versions2.candidates[0].height
            }

            if(item.media_type == 1)
            {
                mainLoader.source = "LoaderImage.qml"
            }
            else
            {
                mainLoader.source = "LoaderVideo.qml"
            }

        }
        else if(item.media_type == 8)
        {
            var first_image = item.carousel_media.get(0);
            if(!mainItemLoader.isSquared)
            {
                image.height = parent.width/first_image.image_versions2.candidates[0].width*first_image.image_versions2.candidates[0].height
            }
            mainLoader.source = "LoaderCarusel.qml"
        }

        if(mainItemLoader.isSquared)
        {
            image.height = image.width
        }
    }
}
