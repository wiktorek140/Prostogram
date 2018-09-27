import QtQuick 2.0
import Sailfish.Silica 1.0
import "../itemLoader.js" as ItemLoader
import "../MediaTypes.js" as MediaType

//reworked

Rectangle {
    id: image
    property bool preview: false
    property bool autoVideoPlay: !preview
    property bool isSquared: false

    width: parent.width

    anchors {
        left: parent.left
        right: parent.right
    }

    Component.onCompleted: {
        if(preview && item.media_type === MediaType.VIDEO_TYPE) item.media_type = MediaType.VIDEO_PREVIEW_TYPE;
        if(isSquared) image.height = image.width;

        if(preview){
            ItemLoader.createComponentObjects("LoaderPreview.qml", {"url":
                                                      (item.media_type === MediaType.CARUSEL_TYPE? item.carousel_media.get(0).image_versions2.candidates[1].url : item.image_versions2.candidates[1].url)
                                              }, image);
        }
        else {
            switch (item.media_type) {
            case MediaType.IMAGE_TYPE:
                image.height = (width/item.image_versions2.candidates[0].width) * item.image_versions2.candidates[0].height;
                ItemLoader.createComponentObjects("LoaderImage.qml", {"url": item.image_versions2.candidates[0].url}, image);
                break;

            case MediaType.VIDEO_TYPE:
                image.height = (width / item.original_width) * item.original_height;
                ItemLoader.createComponentObjects("LoaderVideo.qml", {"url": item.image_versions2.candidates[0].url,
                                                      "videoUrl": item.video_versions.get(0).url,
                                                      "autoVideoPlay": autoVideoPlay}, image);
                if(item.image_versions2.candidates[0].url === 'undefined') {
                    //print(JSON.toString(item))
                }

                break;
            case MediaType.CARUSEL_TYPE:
                image.height = (width / item.carousel_media.get(0).original_width) *
                        item.carousel_media.get(0).original_height;
                ItemLoader.createComponentObjects("LoaderCarusel.qml", {"url": item.carousel_media}, image);
                break;
            case MediaType.VIDEO_PREVIEW_TYPE:
                image.height = (width/item.image_versions2.candidates[0].width) * item.image_versions2.candidates[0].height;
                ItemLoader.createComponentObjects("LoaderVideoPreview.qml", {"url": item.image_versions2.candidates[1].url}, image);
                break;
            }
        }
        //print("ChidrenSize:" + children.height)
    }
}
