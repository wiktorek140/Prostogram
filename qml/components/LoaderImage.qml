import QtQuick 2.0
import harbour.prostogram.cache 1.0

//Reworked

Image {
    property var url

    id: mainImage
    width: parent.width
    anchors.top: parent.top
    fillMode: Image.PreserveAspectFit

    Component.onCompleted: {
        mainImage.source = imageCache.getFromCache(url);
        height = (width/sourceSize.width) * sourceSize.height
        sourceSize.height = height
        sourceSize.width = width
    }
    onStatusChanged: {
        if(mainImage.status === Image.Error) {
            mainImage.source = imageCache.getFromCache(url,true);
        }
    }
}
