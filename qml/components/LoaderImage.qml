import QtQuick 2.0
import harbour.prostogram.cache 1.0

Image {
    id: mainImage
    width: parent.width
    height: parent.height
    visible: true
    fillMode: Image.PreserveAspectFit
    onVisibleChanged: {
        if (!visible){
        source: ""
        }
    }

    CacheImage {
        id:cache
    }

    source: cache.getFromCache(item.image_versions2.candidates[0].url)
}
