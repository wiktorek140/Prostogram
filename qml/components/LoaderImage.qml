import QtQuick 2.0

Image {
    id: mainImage

    width: parent.width
    height: parent.height

    fillMode: Image.PreserveAspectCrop

    source: item.image_versions2.candidates[0].url
}
