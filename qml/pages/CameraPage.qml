import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: galleryPage

    property string image_url

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + header.height
        contentWidth: parent.width

        PageHeader {
            id: header
            title: qsTr("Set photo")
        }

        Column {
            id: column
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            width: parent.width

            Rectangle{
                width: parent.width
                height: parent.width
                clip: true

                Camera {
                    id: camera

                    imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

                    exposure {
                        exposureCompensation: -1.0
                        exposureMode: Camera.ExposurePortrait
                    }

                    flash.mode: Camera.FlashRedEyeReduction

                    imageCapture {
                        onImageCaptured: {
                            photoPreview.source = preview  // Show the preview in an Image
                        }
                    }
                }

                VideoOutput {
                    source: camera
                    width: parent.width
                    fillMode: VideoOutput.PreserveAspectFit
                    clip: true
                    focus : visible // to receive focus and capture key events when visible
                }

                Image {
                    id: photoPreview
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    width: parent.width
                    height: parent.height
                    clip: true
                }
            }
        }
    }
}
