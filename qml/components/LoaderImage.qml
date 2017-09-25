import QtQuick 2.0
import harbour.prostogram.cache 1.0

Image {

    CacheImage {
        id:cache
    }

    id: mainImage
    width: parent.width
    height: parent.height
    fillMode: Image.PreserveAspectFit
    source: {
        if(item.special === 1) {
            "../images/next.svg";
        }
        else cache.getFromCache(item.image_versions2.candidates[0].url)
    }
}
