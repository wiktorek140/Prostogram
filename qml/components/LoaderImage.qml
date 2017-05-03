import QtQuick 2.0

Image {
    id: mainImage

    width: parent.width
    height: parent.height

    source: item.image_versions2.candidates[0].url
}
